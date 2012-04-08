module Hopper
  # How much swearing goes on in a Project?
  #
  # No really. Just fucking tell me already.
  class Swearing < Probe
    # The data for this Probe.
    exposes :word_count

    # The description.
    #
    # Returns a String.
    def self.description
      "Analyze code for dirty words."
    end

    # The list of uncomfortable swear words that made This Programmer nervous as
    # he typed them in.
    #
    # Returns an Array of Strings.
    def words
      %w(
        shit
        fuck
        ass
        cunt
        dick
        cock
        pussy
      )
    end

    # The count of all swear words that show up in this project.
    #
    # Returns an Integer.
    def word_count
      repository.files.map do |file|
        words.map do |word|
          content = repository.read(:path => file)
          content ? content.scan(/\b#{word}\b/).size : 0
        end.sum
      end.sum
    end
  end
end