module Hopper
  class Whitespace < Probe
    exposes :trailing_count, :trailing_percent

    # The description.
    #
    # Returns a String.
    def self.description
      "Whitespace-related analysis."
    end

    # The number of lines in the project that end with trailing whitespace.
    #
    # Returns an Integer.
    def trailing_count
      repository.files.map do |file|
        repository.read(file).lines.map do |line|
          line.scan(/[ \t]+$/).size
        end.sum
      end.sum
    end

    # The percent of lines in this project that have trailing whitespace.
    #
    # Returns a Float.
    def trailing_percent
      total = repository.files.map do |file|
        repository.read(file).lines.count
      end.sum

      trailing_count.to_f / total
    end
  end
end