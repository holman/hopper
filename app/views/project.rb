module Hopper
  module Views
    class Project < Layout
      def project
        @project
      end

      def probes
        Probe.all_as_constants
      end
    end
  end
end