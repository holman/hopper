module Hopper
  # Analysis of the commits that go into this repo.
  class Commits < Probe
    # The data for this Probe.
    exposes :total_count

    # The description.
    #
    # Returns a String.
    def description
      "Explores details about the commits in a repo."
    end

    # The total number of commits.
    #
    # Returns an Integer.
    def total_count
      `cd #{project.path} && git rev-list --all | wc -l`.strip.to_i
    end

    # The day this repo was created.
    #
    # Returns a DateTime.
    def birthday
      date = `git log --reverse --pretty=format:%ad'' | head -1`.strip
      DateTime.parse(date)
    end
  end
end