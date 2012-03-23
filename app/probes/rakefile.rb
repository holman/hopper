module Hopper
  class Rakefile < Probe
    exposes :rakefile_present

    # The description.
    #
    # Returns a String.
    def description
      "rake and Rakefiles."
    end

    # Is a Gemfile present in this project?
    #
    # Returns a binary integer.
    def rakefile_present
      binary_integer Dir.glob("#{project.path}/Rakefile")
    end
  end
end