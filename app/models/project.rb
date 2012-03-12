module Hopper
  # A collection of code that we grab from somewhere. This is our common
  # interface for manipulating the project itself once we have it locally.
  #
  # Redis Keys:
  #
  #   hopper:projects - All of the Project URLs.
  class Project
    # The relative URL of this project.
    #
    # Returns a String.
    attr_accessor :url

    # The main redis key.
    #
    # Returns a String.
    def self.key
      "#{Hopper.redis_namespace}:projects"
    end

    # Initializes a new Project.
    #
    # path - The String path to this project.
    def initialize(url)
      @url = url
    end

    # All Projects.
    #
    # Returns an Array.
    def self.all
      $redis.smembers key
    end

    # Saves the project to the database.
    #
    # Returns nothing.
    def save
      $redis.sadd Project.key, url
    end

    # The path to this project on-disk.
    #
    # Returns a String.
    def path
      "test/examples/simple"
    end

    # All files in this project.
    #
    # Returns an Array of Strings.
    def files
      Dir.glob(File.join(path,"*"))
    end

    # All of the contents of each file in this project.
    #
    # Returns an Array of Strings.
    def file_contents
      files.map do |file|
        File.read(file)
      end
    end

    # The Great Bambino. Runs through all Probes and gives us an analysis of
    # this Project.
    #
    # Returns nothing.
    def analyze!
      Probe.analyze!(self)
    end
  end
end