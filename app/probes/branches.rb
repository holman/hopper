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
      `cd #{project.path} &&
       git branch -r | tail -n +2 | wc -l`.strip.to_i
    end
  end
end