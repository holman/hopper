module Hopper
  class Probe
    # Load all probes.
    Dir["app/probes/*.rb"].each {|file| require file }

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