require 'ruby_parser'

module Hopper
  class Methods < Probe
    exposes :class_count, :instance_count

    # The description.
    #
    # Returns a String.
    def description
      "Methods! They can be cool too."
    end

    # The number of methods in a project.
    #
    # Returns an Integer.
    def class_count
      code = RubyParser.new.parse(project.ruby_contents_string)
      code ? code.flatten.count(:defs) : 0
    end

    # The number of methods in a project.
    #
    # Returns an Integer.
    def instance_count
      code = RubyParser.new.parse(project.ruby_contents_string)
      code ? code.flatten.count(:defn) : 0
    end
  end
end