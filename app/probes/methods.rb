module Hopper
  class Methods < Probe
    exposes :class_count, :instance_count, :method_name_length

    # The description.
    #
    # Returns a String.
    def self.description
      "Methods! They can be cool too."
    end

    # The number of methods in a project.
    #
    # Returns an Integer.
    def class_count
      repository.files(:pattern => /.rb/).map do |file|
        content = repository.read(file)
        count_calls(:defs,content)
      end.sum
    end

    # The number of methods in a project.
    #
    # Returns an Integer.
    def instance_count
      repository.files(:pattern => /.rb/).map do |file|
        content = repository.read(file)
        count_calls(:defn,content)
      end.sum
    end

    # The average length of method names in this project.
    #
    # Returns an Integer.
    def method_name_length
      repository.files(:pattern => /.rb/).map do |file|
        content = repository.read(file)
        count_method_length(:defn,content) + count_method_length(:defs,content)
      end.average
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
    rescue Exception => e
      0
    end

    def count_method_length(target,file)
      total = []
      RubyParser.new.parse(file).each_of_type(target) do |method|
        if target == :defn
          total << method[1].to_s.length
        else
          total << method[2].to_s.length
        end
      end
      total
    rescue Exception
      []
    end
  end
end