module Hopper
  module Views
    class Project < Layout
      def project
        @project
      end

      def versioned_probes
        @project.versioned_probes
      end
    end
  end
end