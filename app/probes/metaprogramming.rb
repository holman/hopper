module Hopper
  class Metaprogramming < Probe
    # The data for this Probe.
    exposes :define_method_count, :send_count

    # The description.
    #
    # Returns a String.
    def self.description
      "Methods of metaprogramming."
    end

    # The total number of instances of "define_method".
    #
    # Returns an Integer.
    def define_method_count
      project.file_contents.map do |file|
        file.scan(/define_method/).size
      end.sum
    end

    # The total number of instances of "send".
    #
    # Returns an Integer.
    def send_count
      project.file_contents.map do |file|
        file.scan(/\.send/).size
      end.sum
    end
  end
end