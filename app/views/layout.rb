module Hopper
  module Views
    class Layout < Mustache
      def title
        "Hopper"
      end

      def section_link
        @path ||= ''
        section = @path.split('/')[1]
        "<a href=\"/#{section}\">#{section}</a>"
      end

      # We have a secondary nav under the main nav. This always looks for
      # secondaries/page_name.mustache.
      def secondaries
        file = self.class.name.split('::').last.gsub(/(.)([A-Z])/,'\1_\2').downcase
        path = "app/templates/secondaries/#{file}.mustache"


        Mustache.render(File.read(path), self) if File.exist?(path)
      end
    end
  end
end