module Hopper
  module Views
    class Project < Layout
      def project
        @project
      end

      def probes
        @project.probes
      end
    end
  end
end