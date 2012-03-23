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
      project.ruby_file_contents.inject(0) do |total,file|
        total += count_calls(:defs,file)
      end
    end

    # The number of methods in a project.
    #
    # Returns an Integer.
    def instance_count
      project.ruby_file_contents.inject(0) do |total,file|
        total += count_calls(:defn,file)
      end
    end

  private

    # Count the number of specific occurances of the AST. This is a private
    # convenience method so we can rescue on parse errors.
    #
    # call - The Symbol AST object we're looking for. For example, :defs for
    #        class methods, :defn for instance methods, and so on.
    # file - The String file contents to investigate.
    #
    # Returns an Integer of the number of occurances found.
    def count_calls(call,file)
      code = RubyParser.new.parse(file)
      code ? code.flatten.count(call) : 0
    rescue Racc::ParseError => e
      0
    end
  end
end