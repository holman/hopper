module Hopper
  class Gemspecs < Probe
    exposes :present

    # The description.
    #
    # Returns a String.
    def description
      "Gemspec-related discoveries."
    end

    # Is there a gemspec present?
    #
    # Returns an Integer. 1 if present, 0 if not.
    def present
      binary_integer Dir.glob("#{project.path}/*.gemspec")
    end
  end
end