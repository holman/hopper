module Hopper
  class Rakefile < Probe
    exposes :rakefile_present

    # The description.
    #
    # Returns a String.
    def self.description
      "rake and Rakefiles."
    end

    # Is a Gemfile present in this project?
    #
    # Returns a binary integer.
    def rakefile_present
      repository.file_exists?('Rakefile') ? 1 : 0
    end
  end
end