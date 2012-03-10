module Hopper
  # A measurement of Lines of Code in a Project.
  #
  # In practice, there's a few things we look at:
  #
  #   - lines
  #   - lines of actual code
  #   - lines of documentation
  class Loc < Probe
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
      project.files.inject(0) do |sum,file|
        sum + File.read(file).lines.count
      end
    end

    # A count of the number of lines of code in .rb files.
    #
    # Returns an Integer.
    def ruby_lines
      project.files.inject(0) do |sum,file|
        return sum if File.extname(file) != '.rb'
        sum + File.read(file).lines.count
      end
    end

    # Number of lines in the project that are commented.
    #
    # Returns an Integer.
    def comment_lines
      project.files.inject(0) do |sum,file|
        sum + File.read(file).lines.collect do |line|
          first = line.strip[0]
          first = first.chr if first
          first == '#' ? 1 : 0
        end.sum
      end
    end

    # Save LOC counts.
    #
    # Returns a Boolean of whether or not it saved.
    def save
      puts "saved!"
    end
  end
end