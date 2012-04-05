module Hopper
  class Branches < Probe
    exposes :count

    # The description.
    #
    # Returns a String.
    def self.description
      "Analysis of development branches."
    end

    # The number of branches in this SCM'd project.
    #
    # Returns an Integer.
    def count
      repo.refs.count{|ref| ref =~ /remotes/ && !(ref =~ /HEAD/) }
    end
  end
end