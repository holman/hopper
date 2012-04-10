module Hopper
  module Views
    class Project < Layout
      def title
        @project.source.name
      end

      def project
        @project
      end

      def project_name
        @project.source.name
      end

      def project_id
        @project.id
      end

      def probes
        @project.completed_probes
      end
    end
  end
end