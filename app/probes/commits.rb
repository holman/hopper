module Hopper
  # Analysis of the commits that go into this repo.
  class Commits < Probe
    # The data for this Probe.
    exposes :total_count, :commits_per_day, :days_old

    # The description.
    #
    # Returns a String.
    def self.description
      "Explores details about the commits in a repo."
    end

    # The total number of commits.
    #
    # Returns an Integer.
    def total_count
      walker.push(revision)
      walker.count
    end

    # Commits per day metric.
    #
    # Returns a Float.
    def commits_per_day
      total_count.to_f / days_old
    end

    # The day this repo was created.
    #
    # Returns a Time.
    def birthday
      walker.sorting(Rugged::SORT_TOPO)
      walker.push(revision)
      commit = walker.to_a.last
      Time.at(commit.time)
    end

    # The number of days old this project is.
    #
    # Returns an Integer.
    def days_old(to=Time.now)
      ((to - birthday) / 60 / 60 / 24).to_i
    end
  end
end