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
    exposes :lines, :ruby_lines, :comment_lines

    # The description.
    #
    # Returns a String.
    def description
      "A simple lines of code count."
    end

    # A count of the number of lines in the Project.
    #
    # Returns an Integer.
    def lines
      project.files.map do |file|
        File.directory?(file) ? 0 : File.read(file).lines.count
      end.sum
    end

    # A count of the number of lines of code in .rb files.
    #
    # Returns an Integer.
    def ruby_lines
      project.files.map do |file|
        return 0 if File.extname(file) != '.rb'
        return File.read(file).lines.count
      end.sum
    end

    # Number of lines in the project that are commented.
    #
    # Returns an Integer.
    def comment_lines
      project.files.map do |file|
        if File.directory?(file)
          0
        else
          File.read(file).lines.map do |line|
            first = line.strip[0]
            first = first.chr if first
            first == '#' ? 1 : 0
          end.sum
        end
      end.sum
    end
  end
end