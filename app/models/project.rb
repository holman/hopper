require 'digest/sha1'

module Hopper
  # A collection of code that we grab from somewhere. This is our common
  # interface for manipulating the project itself once we have it locally.
  #
  # Redis Keys:
  #
  #   hopper:projects                 - All of the Project URLs.
  #   hopper:projects:#{id}:head      - The HEAD (main) sha to analyze.
  #   hopper:projects:#{id}:snapshots - A List of shas used for snapshots.
  class Project
    # Highly prioritize.`
    @queue = :index

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
      self.url = url
      @id      = sha1
    end

    # Initializes and saves a new Project.
    #
    # Returns the Project.
    def self.create(url)
      project = new(url)
      project.async_save
      project
    end

    # Finds a Project from an ID.
    #
    # Returns the Project.
    def self.find(id)
      hash = $redis.hgetall("#{Project.key}:#{id}")
      new(hash['url'])
    end

    # The main redis key.
    #
    # Returns a String.
    def self.key
      "#{Hopper.redis_namespace}:projects"
    end

    # The HEAD revision of this project.
    #
    # Returns a String.
    def head_key
      "#{Project.key}:#{id}:head"
    end

    # The redis key of snapshots. This is a redis List.
    #
    # Returns a String.
    def snapshots_key
      "#{Project.key}:#{id}:snapshots"
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

    # An URL. Just assume HTTP for now.
    #
    # Returns a String.
    def url_with_protocol
      "https://#{url}"
    end

    # The HEAD revision of the project. In other words, what's currently the
    # latest commit we have.
    #
    # Returns a String.
    def head_revision
      $redis.get head_key
    end

    # The slices of the repository at various points in time.
    #
    # Returns an Array of Strings, each a sha hash pointing to the git repo.
    def snapshots
      $redis.lrange snapshots_key, 0, -1
    end

    # Generate slices of the repository. This should only be run once, as shas
    # will likely change after new commits are fetched.
    #
    # Slices are defined as ten snapshots in time of a repository. We basically
    # take every nth sha in a repository so that we end up with ten values. If a
    # repo has less than ten revisions, we just take them all.
    #
    # Returns nothing.
    def snapshots!
      repo = Rugged::Repository.new(path)
      walker = Rugged::Walker.new(repo)
      walker.push(repo.head.target)
      revisions = walker.map(&:oid)

      count = revisions.length

      if count >= 10
        slice_at  = count / 10
        revisions = revisions.each_slice(slice_at).map(&:first)[0..9]
        save_snapshots(revisions)
      else
        save_snapshots(revisions)
      end

      $redis.set head_key, revisions.first.strip
    end

    # Accesses the Source for this Project.
    #
    # Returns a Source.
    def source
      @source ||= Source.new_from_url(url)
    end

    # The method Resque uses to asynchronously do the dirty.
    #
    # project_id - The String project_id.
    #
    # Returns whatever Resque returns.
    def self.perform(url)
      new(url).save
    end

    # Asynchronously save a model.
    #
    # Returns nothing.
    def async_save
      Resque.enqueue(Project, url)
    end

    # Saves the project to the database.
    #
    # Returns nothing.
    def save
      $redis.sadd Project.key, id

      hash_id = "#{Project.key}:#{id}"
      $redis.hset hash_id, :url, url

      analyze
    end

    # The path to this project on-disk.
    #
    # Returns a String.
    def path
      source.local_path
    end

    # Access this project's probes (which should be all probes available).
    #
    # Returns an Array of Probe instances.
    def probes
      Probe.all.map do |probe|
        probe.new(self)
      end
    end

    # Returns all probes attached to this project, *and* all versions of those
    # probes.
    #
    # Returns an Array of the form:
    #   [
    #     OpenStruct(:name, :description, :probes)
    #   ]
    def versioned_probes
      shas = snapshots
      Probe.all.map do |probe|
        struct = OpenStruct.new
        struct.name = probe.name.downcase.to_sym
        struct.description = probe.description
        struct.probes = shas.map { |snapshot| probe.new(self,snapshot) }
        struct
      end
    end

    # Returns all of the versioned, historical Probes for this project for a
    # specific probe class.
    #
    # probe - The Class constant of a Probe, like `Commits`.
    #
    # Returns an Array of Probes of all the same subclass (ie, 10 instances of
    # the Swearing probe).
    def versioned_probe(probe)
      snapshots.map do |snapshot|
        probe.new(self,snapshot)
      end
    end

    # The Great Bambino. Runs through all Probes and gives us an analysis of
    # this Project.
    #
    # Returns nothing.
    def analyze
      source.clone
      snapshots!
      Probe.analyze(self)
    end

  private
    # Save an Array of revisions to redis as snapshots.
    #
    # revisions - An Array of Strings.
    #
    # Returns nothing.
    def save_snapshots(revisions)
      revisions.each do |revision|
        $redis.rpush snapshots_key, revision.strip
      end
    end
  end
end