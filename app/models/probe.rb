module Hopper
  # A Probe is a look into a particular metric of a Project.
  #
  # We typically run a number of Probes over a Project. Each Probe subclasses
  # this main class, which provides a common interface for some convenience
  # methods, like identifiers and helper methods, as well as some global finders
  # and accessors.
  class Probe
    # Load all probes.
    Dir["app/probes/*.rb"].each {|file| require file }

    # Public: The Project this Probe is probing.
    #
    # Returns a Project.
    attr_accessor :project

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
      File.basename(__FILE__, '.rb').capitalize
    end

    # Public: Get the Probe to analyze data and store it away.
    #
    # Returns nothing.
    def save
      raise NotImplementedError
    end

    # Public: The description of the probe.
    #
    # Returns a String.
    def description
      raise NotImplementedError
    end

    # Public: Raised if the method hasn't been properly defined in the subclass.
    class NotImplementedError < StandardError ; end
  end
end