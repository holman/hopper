module Hopper
  module Views
    class ProjectProbe < Layout
      def title
        @probe.name
      end

      def probes
        Probe.all
      end

      def project
        @project
      end

      def project_id
        @project.id
      end

      def project_name
        @project.source.name
      end

      def probe
        @probe
      end

      def probe_name
        @probe.name
      end

      def data
        @probe.versioned_data
      end
    end
  end
end