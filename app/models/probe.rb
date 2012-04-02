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
  #   hopper:projects:#{probe}
  #     A List of the aggregate values for a Probe.
  #
  #   hopper:projects:#{probe}:#{id}:#{revision}
  #     The value of a particular probe on a project and revision basis.
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
      self.class.exposed.collect do |method|
        value = $redis.get "#{key}:#{method}:#{project.id}:#{revision}"
        hash[method.to_sym] = value
      end
      hash
    end

    # The aggregate data from all of this mess.
    #
    # Returns a Hash of Arrays.
    def self.aggregates
      exposed.map do |method|
        value = $redis.lrange "#{key}:#{method}", 0, 10
        Hopper::Views::Aggregate.new(method, value)
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
    # checkout - Should we switch our working copy out to the correct branch? If
    #            you're running analysis, this should be set to `true` (which
    #            is the default). If you're just loading the Probe for accessing
    #            data, set it to `false`.
    #
    # Returns a new Probe.
    def initialize(project, revision=project.head_revision, checkout=true)
      @project  = project
      @revision = revision

      checkout_revision if checkout
    end

    # Public: Checks out the current revision so we can run operations on the
    # repo without having to switch to it every time.
    #
    # Returns nothing.
    def checkout_revision
      system("cd #{project.path} && git checkout #{revision} --quiet")
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
      all.each{|probe| probe.new(project).save }
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
      names = Dir["app/probes/*.rb"].map{|file| File.basename(file,'.rb')}
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

    # Public: Get the Probe to analyze data and store it away.
    #
    # Returns nothing.
    def save
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
        rescue Exception => e
          puts "Problem saving #{name}:#{method} - #{e}"
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
      result.empty? ? 0 : 1
    end

    # Public: Raised if the method hasn't been properly defined in the subclass.
    class NotImplementedError < StandardError ; end

    # Load all probes.
    Dir["app/probes/*.rb"].each {|file| require file }
  end
end