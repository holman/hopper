module Hopper
  # Analysis of the contributors in this repo.
  class Contributors < Probe
    # The data for this Probe.
    exposes :total_count, :contributors

    # The description.
    #
    # Returns a String.
    def self.description
      "Explores details about the contributors in a repo."
    end

    # The total number of commits.
    #
    # Returns an Integer.
    def total_count
      `cd #{project.path} && git shortlog -s | wc -l`.strip.to_i
    end

    # The contributors to this project.
    #
    # Returns an Array of Hashes, with keys as :author, :email, :count.
    def contributors
      `cd #{project.path} && git shortlog -s -e`.map do |line|
        count  = line.split("\t").first.to_i
        email  = line.scan(/<(.*)>/).first.first.strip
        author = line.scan(/(.*)</).first.first.split("\t").last.strip
        {
          :author => author,
          :email  => email,
          :count  => count
        }
      end
    end
  end
end