module Hopper
  # A measurement of Lines of Code in a Project.
  #
  # In practice, there's a few things we look at:
  #
  #   - lines
  #   - lines of actual code
  #   - lines of documentation
  class Loc < Probe
    # The data for this Probe.
    exposes :lines, :ruby_lines, :comment_lines, :average_width, :percent_80c

    # The description.
    #
    # Returns a String.
    def self.description
      "A simple lines of code count."
    end

    # A count of the number of lines in the Project.
    #
    # Returns an Integer.
    def lines
      repository.files.map do |file|
        repository.read(file).lines.count
      end.sum
    end

    # A count of the number of lines of code in .rb files.
    #
    # Returns an Integer.
    def ruby_lines
      repository.files(:pattern => /.rb/).map do |file|
        repository.read(file).lines.count
      end.sum
    end

    # Number of lines in the project that are commented.
    #
    # Returns an Integer.
    def comment_lines
      repository.files.map do |file|
        content = repository.read(file)
        content.lines.map do |line|
          first = line.strip[0]
          first = first.chr if first
          first == '#' ? 1 : 0
        end.sum
      end.sum
    end

    # Average line width of the project.
    #
    # Returns a Float.
    def average_width
      width_sum / widths.size.to_f
    end

    # The percentage of lines over 80 characters.
    #
    # Returns a Float.
    def percent_80c
      total = widths.select{|line| line > 80}.count
      total / widths.size.to_f
    end

  private
    def widths
      raise
    end

    def width_sum
      widths.sum
    end
  end
end