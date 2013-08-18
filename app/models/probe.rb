module Hopper
  # A Probe is a look into a particular metric of a Project.
  #
  # We typically run a number of Probes over a Project. Each Probe subclasses
  # this main class, which provides a common interface for some convenience
  # methods, like identifiers and helper methods, as well as some global finders
  # and accessors.
  #
  # Each Probe is responsible for stashing and retreiving its own data. Each
  # Probe MUST implement the following:
  #
  #   - data: A Hash representation of all of the Probe's data. This is a
  #           schemaless Hash, as each Probe can have different needs.
  #   - save: Persists all data to Redis.
  #
  # Redis Keys:
  #
  #   hopper:probes:#{probe}
  #     A List of the aggregate values for a Probe.
  #
  #   hopper:probes:#{probe}:#{id}:#{revision}
  #     The value of a particular probe on a project and revision basis.
  #
  #   hopper:projects:#{id}:complete
  #     A List of the Probes that we've completed analysis on.
  class Probe
    # Public: The Project this Probe is probing.
    #
    # Returns a Project.
    attr_accessor :project

    # Public: The revision in version control to analyze.
    #
    # Returns a String.
    attr_accessor :revision

    # Public: A Hash representation of all of the data persisted by this Probe.
    #
    # Returns a Hash. This Hash is schemaless and is dependent on each Probe's
    # implementation. It generally corresponds to a basic key/value format,
    # where the key maps to a particular metric, and the value is the
    # persisted data we prepared.
    def data
      hash = {}
      self.class.exposed.map do |method|
        value = $redis.get "#{key}:#{method}:#{project.id}:#{revision}"
        hash[method.to_sym] = value
      end
      hash
    end

    # Public: All of the data across all revision snapshots.
    #
    # Returns an Array of OpenStructs, each with the form:
    #   OpenStruct.new :name => probe_name, :values => values
    def versioned_data
      self.class.exposed.map do |method|
        os = OpenStruct.new(:name => Probe.clean_probe_name(method))
        os.values = project.snapshots.reverse.map do |snapshot|
          value = $redis.get("#{key}:#{method}:#{project.id}:#{snapshot}")
          (value == 'NaN' || !value) ? 0 : value
        end
        os
      end
    end

    # Takes a probe name, like line_count, and turns it into "Line count".
    #
    # name - A String name to clean up.
    #
    # Returns a String.
    def self.clean_probe_name(name)
      name.to_s.gsub('_',' ').capitalize
    end

    # The aggregate data from all of this mess.
    #
    # Returns a Hash of Arrays.
    def self.aggregates
      exposed.map do |method|
        value = $redis.lrange "#{key}:#{method}", 0, -1
        Hopper::Views::Aggregate.new(method, value)
      end
    end

    # Collect all the statistical base metrics!
    #
    # Returns an Array of OpenStructs (defined with :name and :average).
    def self.metrics
      exposed.map do |method|
        values = $redis.lrange "#{key}:#{method}", 0, -1
        values = values.map{|value| value.to_f}
        OpenStruct.new \
          :name    => Probe.clean_probe_name(method),
          :mean    => values.average,
          :median  => values.median,
          :mode    => values.mode.first
          :stdiv   => values.standard_deviation
      end
    end

    # Public: A convenience method for setting the methods we use to populate
    # the `data` Hash for each Probe.
    #
    # exposed - An Array of Symbols that correspond to method names in the Probe
    #           to query against.
    #
    # Examples:
    #
    #   # Each Probe can declare the data it exposes by something like:
    #   exposes :count, :lines, :total
    #
    # Sets the Hash as accessibile from `data` and returns as such.
    def self.exposes(*exposed)
      self.exposed = exposed
    end

    # Hack to stash `exposed` methods and make them available in the `exposes`
    # API.
    class << self
      attr_accessor :exposed
    end

    # Public: Creates a new Probe.
    #
    # project  - The Project that we're analyzing.
    # revision - The revision (sha1) of the project we're looking at.
    #
    # Returns a new Probe.
    def initialize(project, revision=project.head_revision)
      @project  = project
      @revision = revision
    end

    # Public: Searches for a Probe by name.
    #
    # Returns a Probe.
    def self.find(name)
      all.find{|probe| probe.name.downcase == name.downcase }
    end

    # Public: Analyzes a Project with all the Probes we have at our disposal.
    #
    # Returns nothing.
    def self.analyze(project)
      all.each do |probe|
        project.snapshots.each do |snapshot|
          probe.new(project,snapshot).async_save
        end
      end
    end

    # The key for this probe in redis.
    #
    # Returns a String.
    def self.key
      "#{Hopper.redis_namespace}:probes:#{self.name.downcase}"
    end

    # The key for this probe in redis.
    #
    # Returns a String.
    def key
      "#{Hopper.redis_namespace}:probes:#{name.downcase}"
    end

    # Public: All Probes.
    #
    # Returns an Array of Constants.
    def self.all
      names = Dir["app/probes/*.rb"].map{|file| File.basename(file,'.rb')}.sort
      names.map{|klass| Hopper.const_get(klass.capitalize)}
    end

    # Public: The name of the probe, generated from the file name.
    #
    # Returns a String.
    def self.name
      super.split('::').last.capitalize
    end

    # The description of the probe.
    #
    # Returns a String.
    def self.description
      raise NotImplementedError
    end

    # Public: The description of the probe.
    #
    # Returns a String.
    def description
      self.class.description
    end

    # Public: The name of the probe, generated from the file name.
    #
    # Returns a String.
    def name
      self.class.name.split('::').last.capitalize
    end

    # A shortcut to the repository object for this probe.
    #
    # Returns a Repository instance.
    def repository
      @repository ||= Repository.new(:path => project.path, :revision => revision)
    end

    # A shortcut to the walker object for this probe.
    #
    # Returns an instance of Rugged::Walker.
    def walker
      @walker ||= repository.walker
    end

    # The method Resque uses to asynchronously do the dirty.
    #
    # project_id - The String project_id.
    # revision   - The revision to analyze.
    #
    # Returns whatever Resque returns.
    def self.perform(project_id, revision)
      project = Project.find(project_id)
      new(project, revision).save
    end

    # Default all queues to be :probes.
    #
    # Returns a Symbol.
    def self.queue
      :probe
    end

    # Queue up a job to analyze this project. The queue is defaulted to :high,
    # unless the subclass overrides that (which is typically reserved in cases
    # of really slow probes).
    #
    # Returns a boolean.
    def async_save
      Resque::Job.create(self.class.queue, self.class, project.id, revision)
    end

    # Public: Get the Probe to analyze data and store it away.
    #
    # Returns nothing.
    def save
      # Re-clone the repo if it doesn't exist on-disk. This is mostly for
      # running multiple worker processes who don't share disk. If this same
      # worker process has already run #clone, then #clone will bail out early
      # without re-cloning.
      project.source.clone

      self.class.exposed.collect do |method|
        begin
          # Cache the result
          result = self.send(method)

          # Add the individual record
          $redis.set "#{key}:#{method}:#{project.id}:#{revision}", result

          # Add the aggregate record
          #
          # TODO: do we really want to add each revision, or just the head
          #       revision?
          $redis.rpush "#{key}:#{method}", result

          # Keep track of what we've analyzed.
          $redis.sadd "#{Hopper.redis_namespace}:projects:#{project.id}:complete", self.name
        rescue Exception => e
          raise e, "Problem saving #{name}:#{method}"
        end
      end
    end

    # Takes a `result` and returns either 1 if there are values present, or 0 if
    # there aren't. Designed to avoid booleans to help promote good graphing.
    #
    # result - An Array of objects.
    #
    # Returns 1 if values present, 0 if not.
    def binary_integer(result)
      result.any? ? 1 : 0
    end

    # Export the raw data to CSV.
    #
    # Returns a String.
    def self.to_csv
      exposed.map do |method|
        values = $redis.lrange "#{key}:#{method}", 0, -1
        values.map{|value| value.to_f}.join("\n")
      end.join("")
    end

    # Public: Raised if the method hasn't been properly defined in the subclass.
    class NotImplementedError < StandardError ; end

    # Load all probes.
    Dir["app/probes/*.rb"].each do |file|
      file = File.basename(file)
      require_relative "../probes/#{file}"
    end
  end
end