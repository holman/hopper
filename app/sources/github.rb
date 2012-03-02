module Hopper
  class Github < Source
    # The name of the Source.
    #
    # Returns a String.
    def name
      "GitHub"
    end

    # The main URL of the Source.
    #
    # Returns a String.
    def url
      "https://github.com"
    end
  end
end