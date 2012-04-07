module Hopper
  # Analysis of the contributors in this repo.
  class Contributors < Probe
    # The data for this Probe.
    exposes :contributors_count

    # The description.
    #
    # Returns a String.
    def self.description
      "Explores details about the contributors in a repo."
    end

    # The number of contributors to this project.
    #
    # Returns an Integer.
    def contributors_count
      contributors.size
    end

    # The contributors to this project.
    #
    # Returns an Array of Hashes, with keys as :author, :email, :count.
    def contributors
      return @contributors if @contributors

      contributors = {}

      walker.push(revision)
      walker.each do |commit|
        author = commit.author
        email = author[:email]
        if contributors[email]
          contributors[email] = {
            :author => author[:name],
            :count  => contributors[email][:count] + 1
          }
        else
          contributors[email] = {
            :author => author[:name],
            :count  => 1
          }
        end
      end

      @contributors = contributors
    end
  end
end