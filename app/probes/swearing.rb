module Hopper
  class Swearing < Probe
    def description
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
      words.map do |word|
        project.file_contents.join(' ').scan(/\b#{word}\b/).size
      end.inject(:+)
    end
  end
end