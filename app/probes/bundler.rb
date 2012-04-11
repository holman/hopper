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
      tree = repository.repo.lookup(revision).tree
      gemfiles = tree.select{|item| item[:name] == 'Gemfile' }
      binary_integer gemfiles
    end

    # Is a Gemfile present in this project?
    #
    # Returns a binary integer.
    def gemfile_lock_present
      tree = repository.repo.lookup(revision).tree
      locks = tree.select{|item| item[:name] == 'Gemfile.lock' }
      binary_integer locks
    end

    # The number of gems used in this Gemfile.
    #
    # Returns an Integer.
    def gems_used
      tree = repository.repo.lookup(revision).tree
      gemfile = tree.select{|blob| blob[:name] == 'Gemfile'}.first
      return 0 if !gemfile
      blob = gemfile[:oid]

      content = Rugged::Blob.lookup(repository.repo,blob).content
      Ripper.sexp(content).flatten.count('gem')
    end
  end
end