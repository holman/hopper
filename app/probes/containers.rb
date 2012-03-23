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
  end
end