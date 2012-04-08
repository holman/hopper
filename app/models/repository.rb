module Hopper
  # Repository is a class used to abstract away all disk-related aspects that
  # Probes use to probe a Project.
  #
  # Right now this is tied to Git (via Rugged) for convenience, but in the
  # future it's likely we will subclass Repository for each VCS.
  class Repository
    # The current revision to analyze.
    #
    # Returns a String.
    attr_accessor :revision

    # The path to the repo.
    #
    # Returns a String.
    attr_accessor :path

    # The repo object we use via Rugged.
    #
    # Returns an instance of Rugged::Repository.
    attr_accessor :repo

    # The tree object initialized to the revision.
    #
    # Returns an instance of Rugged::Tree.
    attr_accessor :tree

    # The walker object we use to walk all over the commit tree.
    #
    # Returns an instance of Rugged::Walker.
    attr_accessor :walker

    # Make a new Repository instance.
    #
    # Returns a new Repository instance.
    def initialize(options)
      @revision = options[:revision]
      @path     = options[:path]
      @repo     = Rugged::Repository.new(@path)
      @tree     = @repo.lookup(revision).tree
      @walker   = Rugged::Walker.new(repo)
    end

    # All of the files in this repository. Can also be filtered by a regex.
    #
    # options - A Hash of options:
    #           pattern: A Regular Expression that can be used to selectively
    #                    filter out unwanted files.
    #           tree:    A Rugged::Tree object that lets us filter down (used
    #                    recursively).
    #           prefix:  A String to prefix to a path.
    #
    # Returns an Array of Strings.
    def files(options={})
      # Are we using an existing subtree? Otherwise, just use the repo's tree.
      subtree = options[:tree] || tree
      pattern = options[:pattern]
      prefix  = options[:prefix]

      files = subtree.map do |item|
        if item[:type] == :tree
          subtree = @repo.lookup(item[:oid])
          files(:tree => subtree, :prefix => "#{prefix}#{item[:name]}/")
        else
          "#{prefix}#{item[:name]}"
        end
      end.flatten

      if pattern
        files.select{|file| file =~ pattern}
      else
        files
      end
    end

    # Read a file's contents.
    #
    # path - A String path to a a file.
    #
    # Returns a String.
    def read(path)
      tree = Rugged::Commit.lookup(repo, revision).tree
      subtree = tree.get_subtree(path)
      blob_data = subtree.get_entry(File.basename(path))
      if blob_data && blob_data[:type]
        blob = Rugged::Blob.lookup(repo, blob_data[:oid])
        blob.content
      else
        ''
      end
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
      walker.push(repo.head.target)
      walker.map(&:oid)
    end
  end
end