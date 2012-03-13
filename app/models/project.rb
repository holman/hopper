require 'digest/sha1'

module Hopper
  # A collection of code that we grab from somewhere. This is our common
  # interface for manipulating the project itself once we have it locally.
  #
  # Redis Keys:
  #
  #   hopper:projects - All of the Project URLs.
  class Project
    # The ID of the Project.
    #
    # Returns a String (the sha).
    attr_accessor :id

    # Set the URL of the project. Removes www., removes http(s) protocol.
    #
    # Returns a String.
    def url=(url)
      host = URI.parse(url).host
      path = URI.parse(url).path
      url  = "#{host}#{path}"

      @url = url.gsub(/^www\./,'')
    end

    # The URL of the project.
    #
    # Returns a String.
    attr_reader :url

    # Initializes a new Project.
    #
    # path - The String path to this project.
    def initialize(url)
      @url = url
      @id  = sha1
    end

    # Finds a Project from an ID.
    #
    # Returns the Project.
    def self.find(id)
      hash = $redis.hgetall("#{Project.key}:id")
      new(hash['url'])
    end

    # The main redis key.
    #
    # Returns a String.
    def self.key
      "#{Hopper.redis_namespace}:projects"
    end

    # All Projects.
    #
    # Returns an Array.
    def self.all
      $redis.smembers key
    end

    # The SHA1 representation of the URL.
    #
    # Returns a String.
    def sha1
      Digest::SHA1.hexdigest url
    end

    # Saves the project to the database.
    #
    # Returns nothing.
    def save
      $redis.sadd Project.key, id

      hash_id = "#{Project.key}:id"
      $redis.hset hash_id, :url, url
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

    # Access this project's probes (which should be all probes available).
    #
    # Returns an Array of Probe instances.
    def probes
      Probe.all_as_constants.collect do |probe|
        probe.new(self)
      end
    end

    # The Great Bambino. Runs through all Probes and gives us an analysis of
    # this Project.
    #
    # Returns nothing.
    def analyze
      Probe.analyze(self)
    end
  end
end