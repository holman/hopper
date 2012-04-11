module Hopper
  class Methods < Probe
    exposes :class_count, :instance_count

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
        count_calls(:def,content)
      end.sum
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
      code = Ripper.sexp(file)
      code ? code.flatten.count(call) : 0
    rescue Exception => e
      0
    end
  end
end