module Hopper
  module Views
    class Probes < Layout
      def title
        "All Probes"
      end

      def probes
        @probes
      end
    end
  end
end