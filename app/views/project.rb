module Hopper
  module Views
    class Project < Layout
      def title
        @project.source.name
      end

      def width
        'full'
      end

      def project
        @project
      end

      def probes
        Probe.all
      end
    end
  end
end