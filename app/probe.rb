module Hopper
  class Probe
    def name
      __FILE__
    end

    def description
      raise "This needs to be implemented by the individual probe."
    end
  end
end