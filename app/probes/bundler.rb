module Hopper
  class Bundler < Probe
    exposes :gemfile_present, :gemfile_lock_present, :gems_used

    # The description.
    #
    # Returns a String.
    def self.description
      "Bundler. So hot right now."
    end

    # Is a Gemfile present in this project?
    #
    # Returns a binary integer.
    def gemfile_present
      tree = repo.lookup(revision).tree
      gemfiles = tree.select{|item| item[:name] == 'Gemfile' }
      binary_integer gemfiles
    end

    # Is a Gemfile present in this project?
    #
    # Returns a binary integer.
    def gemfile_lock_present
      tree = repo.lookup(revision).tree
      locks = tree.select{|item| item[:name] == 'Gemfile.lock' }
      binary_integer locks
    end

    # The number of gems used in this Gemfile.
    #
    # Returns an Integer.
    def gems_used
      tree = repo.lookup(revision).tree
      gemfile = tree.select{|blob| blob[:name] == 'Gemfile'}.first
      blob = gemfile[:oid]

      content = Rugged::Blob.lookup(repo,blob).content
      RubyParser.new.parse(content).flatten.count(:gem)
    end
  end
end