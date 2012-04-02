module Hopper
  class Shas < Probe
    exposes :longest_string, :longest_string_length,
            :longest_integer, :longest_integer_length

    # The description.
    #
    # Returns a String.
    def self.description
      "Collects interesting information about SHAs in this project."
    end

    # What's the longest string in SHAs in this project?
    #
    # Returns a String.
    def longest_string
      shas = `cd #{project.path} && git log --format="%H"`.split("\n")
      Shamazing.string_from_array(shas)
    end

    # What's the longest integer in SHAs in this project?
    #
    # Returns an Integer.
    def longest_integer
      shas = `cd #{project.path} && git log --format="%H"`.split("\n")
      Shamazing.integer_from_array(shas)
    end

    # What is the length of the longest string in SHAs in this project?
    #
    # Returns an Integer.
    def longest_string_length
      longest_string.size
    end

    # What is the length of the longest integer in SHAs in this project?
    #
    # Returns an Integer.
    def longest_integer_length
      longest_integer.to_s.size
    end
  end
end