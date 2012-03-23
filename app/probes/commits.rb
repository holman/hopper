module Hopper
  # Analysis of the commits that go into this repo.
  class Commits < Probe
    # The data for this Probe.
    exposes :total_count, :commits_per_day, :days_old

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

    # Commits per day metric.
    #
    # Returns a Float.
    def commits_per_day
      total_count.to_f / days_old
    end

    # The day this repo was created.
    #
    # Returns a DateTime.
    def birthday
      date = `cd #{project.path} && git log --reverse --pretty=format:%ad'' | head -1`.strip
      DateTime.parse(date)
    end

    # The number of days old this project is.
    #
    # Returns an Integer.
    def days_old(to=Date.today)
      to - Date.parse(birthday.strftime('%Y-%m-%d'))
    end
  end
end