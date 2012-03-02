module Hopper
  class Probe
    # Load all probes.
    Dir["app/probes/*.rb"].each {|file| require file }

    # The Project this Probe is probing.
    #
    # Returns a Project.
    attr_accessor :project

    # Creates a new Probe.
    #
    # project - The Project that we're analyzing.
    #
    # Returns a new Probe.
    def initialize(project)
      @project = project
    end

    # The Probes we have available for use.
    #
    # Returns an Array of Strings.
    def self.all
      Dir["app/probes/*.rb"].map{|file| File.basename(file,'.rb')}
    end

    # The name of the probe, generated from the file name.
    #
    # Returns a String.
    def name
      File.basename(__FILE__, '.rb').capitalize
    end

    # The description of the probe.
    #
    # Returns a String.
    def description
      raise NotImplementedError
    end

    # Raised if the method hasn't been properly defined in the subclass.
    class NotImplementedError < StandardError ; end
  end
end