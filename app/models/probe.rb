module Hopper
  class Probe
    # Load all probes.
    Dir["app/probes/*.rb"].each {|file| require file }

    # The String path to the project.
    attr_accessor :path

    # Creates a new Probe.
    #
    # path - The relative String path to the project.
    #
    # Returns a new Probe.
    def initialize(path='')
      @path = File.expand_path(path)
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