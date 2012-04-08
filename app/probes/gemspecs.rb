module Hopper
  class Gemspecs < Probe
    exposes :present

    # The description.
    #
    # Returns a String.
    def self.description
      "Gemspec-related discoveries."
    end

    # Is there a gemspec present?
    #
    # Returns an Integer. 1 if present, 0 if not.
    def present
      tree = repository.repo.lookup(revision).tree
      specs = tree.select{|item| item[:name] =~ /\.gemspec/ }
      binary_integer specs
    end
  end
end