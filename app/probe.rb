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

    def name
      File.basename(__FILE__, '.rb').capitalize
    end

    def description
      raise NotImplementedError
    end

    class NotImplementedError < StandardError
    end
  end
end