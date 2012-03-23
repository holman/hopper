module Hopper
  class Containers < Probe
    # The data for this Probe.
    exposes :classes_count, :modules_count

    # The description.
    #
    # Returns a String.
    def description
      "Modules and Classes, oh my."
    end

    # The total number of classes defined.
    #
    # Returns an Integer.
    def classes_count
      RubyParser.new.parse(project.ruby_contents_string).flatten.count(:class)
    end

    # The total number of modules defined.
    #
    # Returns an Integer.
    def modules_count
      RubyParser.new.parse(project.ruby_contents_string).flatten.count(:module)
    end

    # Does this project define multiple classes or modules in a file?
    #
    # Returns a binary integer.
    def multiple_per_file
      binary_integer project.ruby_file_contents.map do |file|
        parsed = RubyParser.new.parse(file).flatten
        if parsed.count(:module) > 1 || parsed.count(:class) > 1
           1
        else
          0
        end
      end
    end
  end
end