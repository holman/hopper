module Hopper
  class Popularity < Probe
    exposes :followers, :forks

    def description
      "The popularity of a project, based on followers, forks, and so on."
    end

    # The total number of followers on this repo. Source-specific.
    #
    # Returns an Integer.
    def followers
      project.source.followers
    end

    # The total number of forks this repo has.
    #
    # Returns an Integer.
    def forks
      project.source.forks
    end
  end
end