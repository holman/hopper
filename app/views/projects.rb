module Hopper
  module Views
    class Projects < Layout
      def title
        "All of the Projects"
      end

      def projects
        @projects
      end
    end
  end
end