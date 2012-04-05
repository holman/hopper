module Hopper
  # Analysis of the contributors in this repo.
  class Contributors < Probe
    # The data for this Probe.
    exposes :contributors

    # The description.
    #
    # Returns a String.
    def self.description
      "Explores details about the contributors in a repo."
    end

    # The contributors to this project.
    #
    # Returns an Array of Hashes, with keys as :author, :email, :count.
    def contributors
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

      contributors
    end
  end
end