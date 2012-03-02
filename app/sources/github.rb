module Hopper
  class Github < Source
    # The name of the Source.
    #
    # Returns a String.
    def self.name
      "GitHub"
    end

    # The main URL of the Source.
    #
    # Returns a String.
    def self.url
      "https://github.com"
    end

    # An informal, unique name that we can give it. For GitHub, that's our
    # favorite nwo, like holman/hopper.
    #
    # Returns a String.
    def name
      url.split('/')[-2..-1].join('/')
    end

    # The Git clone URL that lets us pull down this source.
    #
    # Returns a String.
    def clone_url
      "#{url}.git"
    end

    # The clone command needed to clone down this source.
    #
    # Returns a String.
    def clone_command
      "git clone #{clone_url} #{local_path}"
    end
  end
end