module Hopper
  class Popularity < Probe
    exposes :followers, :forks, :open_issues

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

    # The total number of open issues this repo has.
    #
    # Returns an Integer.
    def open_issues
      project.source.open_issues
    end
  end
end