module Hopper
  module Views
    class Probe < Layout
      def title
        @probe.name
      end

      def probes
        Hopper::Probe.all
      end

      def probe
        @probe
      end

      def name
        @probe.name
      end

      def aggregates
        @probe.aggregates
      end

      def metrics
        @probe.metrics
      end
    end
  end
end