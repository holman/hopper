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
  class Probe
    # Public: The Project this Probe is probing.
    #
    # Returns a Project.
    attr_accessor :project

    # Public: A Hash representation of all of the data persisted by this Probe.
    #
    # Returns a Hash. This Hash is schemaless and is dependent on each Probe's
    # implementation. It generally corresponds to a basic key/value format,
    # where the key maps to a particular metric, and the value is the
    # persisted data we prepared.
    def data
      hash = {}
      @@methods.collect do |method|
        hash[method.to_sym] = self.send(method)
      end
      hash
    end

    # Public: A convenience method for setting the methods we use to populate
    # the `data` Hash for each Probe.
    #
    # methods - An Array of Symbols that correspond to method names in the Probe
    #           to query against.
    #
    # Examples:
    #
    #   # Each Probe can declare the data it exposes by something like:
    #   exposes :count, :lines, :total
    #
    # Sets the Hash as accessibile from `data` and returns as such.
    def self.exposes(*methods)
      @@methods = methods
    end

    # Public: Creates a new Probe.
    #
    # project - The Project that we're analyzing.
    #
    # Returns a new Probe.
    def initialize(project)
      @project = project
    end

    # Public: Analyzes a Project with all the Probes we have at our disposal.
    #
    # Returns nothing.
    def self.analyze!(project)
      all_as_constants.each{|probe| probe.new(project).save }
    end

    # Public: The Probes we have available for use.
    #
    # Returns an Array of Strings.
    def self.all
      Dir["app/probes/*.rb"].map{|file| File.basename(file,'.rb')}
    end

    # Public: All Probes, except constantized.
    #
    # Returns an Array of Constants.
    def self.all_as_constants
      all.map{|klass| Hopper.const_get(klass.capitalize)}
    end

    # Public: The name of the probe, generated from the file name.
    #
    # Returns a String.
    def name
      self.class.name.split('::').last.capitalize
    end

    # Public: The description of the probe.
    #
    # Returns a String.
    def description
      raise NotImplementedError
    end

    # Public: Get the Probe to analyze data and store it away.
    #
    # Returns nothing.
    def save
      raise NotImplementedError
    end

    # Public: Raised if the method hasn't been properly defined in the subclass.
    class NotImplementedError < StandardError ; end

    # Load all probes.
    Dir["app/probes/*.rb"].each {|file| require file }
  end
end