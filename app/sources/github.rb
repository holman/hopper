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
      "https://#{url}.git"
    end

    # The clone command needed to clone down this source.
    #
    # Returns a String.
    def clone_command
      "git clone #{clone_url} #{local_path}"
    end

    # The number of commits in this repository.
    #
    # Returns an Integer.
    def commit_count
      revisions.length
    end

    # The revisions in this repository.
    #
    # Returns an Array of Strings.
    def revisions
      `cd #{local_path} && git rev-list --all`.split("\n")
    end

    # The project metadata we fetch from the wire.
    #
    # TODO: This is getting run multiple times on each `metadata` call.
    #
    # Returns a Hash
    def metadata
      Yajl::Parser.parse(`curl https://api.github.com/repos/#{name} --silent`)
    end

    # The number of followers for this project.
    #
    # Returns an Integer.
    def followers
      metadata['watchers']
    end

    # The number of forks for this project.
    #
    # Returns an Integer.
    def forks
      metadata['forks']
    end

    # The number of open issues in this project.
    #
    # Returns an Integer.
    def open_issues
      metadata['open_issues']
    end
  end
end