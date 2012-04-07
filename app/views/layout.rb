module Hopper
  module Views
    class Layout < Mustache
      def title
        "Hopper"
      end

      # We have a secondary nav under the main nav. This always looks for
      # secondaries/page_name.mustache.
      def secondaries
        file = self.class.name.split('::').last.gsub!(/(.)([A-Z])/,'\1_\2').downcase
        Mustache.render(File.read("app/templates/secondaries/#{file}.mustache"))
      end
    end
  end
end