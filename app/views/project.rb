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

      def versioned_probes
        @project.versioned_probes
      end
    end
  end
end