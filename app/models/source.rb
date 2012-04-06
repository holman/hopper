module Hopper
  # A Source is a place where we can get a Project. Usually a version control
  # host.
  #
  # Redis keys:
  #
  #   hopper:sources:#{source}:page
  #     A simple cached reference to the last page from a set of search results
  #     that we indexed from. Makes for easy continuation.
  class Source
    # Load all sources.
    Dir["app/sources/*.rb"].each {|file| require file }

    # The URL of the Project.
    #
    # Returns a String.
    attr_accessor :url

    # Creates a new Source.
    #
    # Returns the Source.
    def initialize(url)
      @url = url
    end

    # Initializes a new Source from a URL.
    #
    # Returns a new Source subclass.
    def self.new_from_url(url)
      # We only have GitHub at the moment. Deal with it.
      Github.new(url)
    end

    # The name of the Source.
    #
    # Returns a String.
    def self.name
      raise NotImplementedError
    end

    # The main URL of the Source.
    #
    # Returns a String.
    def self.url
      raise NotImplementedError
    end

    # Index repos from a listing online.
    #
    # Returns nothing.
    def index
      raise NotImplementedError
    end

    # A unique (for this source) name that we can use.
    #
    # Returns a String.
    def name
      raise NotImplementedError
    end

    # The URL used to download this Source.
    #
    # Returns a String.
    def clone_url
      raise NotImplementedError
    end

    # The clone command needed to pull down the data.
    #
    # Returns a String.
    def clone_command
      raise NotImplementedError
    end

    # Runs the clone_command.
    #
    # Returns nothing.
    def clone
      return if File.exist?(local_path)
      system clone_command
    end

    # The #name attribute, but with special characters subbed out.
    #
    # Returns a String.
    def directory_name
      name.gsub('/','-')
    end

    # The local path of the repository on-disk.
    #
    # Returns a String.
    def local_path
      "#{Hopper.temp_dir}/#{directory_name}"
    end

    # Raised if the method hasn't been properly defined in the subclass.
    class NotImplementedError < StandardError ; end
  end
end