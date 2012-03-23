module Hopper
  class Bundler < Probe
    exposes :gemfile_present, :gemfile_lock_present, :gems_used

    # The description.
    #
    # Returns a String.
    def description
      "Bundler. So hot right now."
    end

    # Is a Gemfile present in this project?
    #
    # Returns a binary integer.
    def gemfile_present
      binary_integer Dir.glob("#{project.path}/Gemfile")
    end

    # Is a Gemfile present in this project?
    #
    # Returns a binary integer.
    def gemfile_lock_present
      binary_integer Dir.glob("#{project.path}/Gemfile.lock")
    end

    # The number of gems used in this Gemfile.
    #
    # Returns an Integer.
    def gems_used
      gemfile = "#{project.path}/Gemfile"
      return nil if !File.exist?(gemfile)

      contents = File.read(gemfile)
      RubyParser.new.parse(contents).flatten.count(:gem)
    end
  end
end