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
      RubyParser.new.parse(project.ruby_contents_string).flatten.count(:defs)
    end

    # The number of methods in a project.
    #
    # Returns an Integer.
    def instance_count
      RubyParser.new.parse(project.ruby_contents_string).flatten.count(:defn)
    end
  end
end