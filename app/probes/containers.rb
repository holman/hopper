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
      project.file_contents.map do |file|
        file.scan(/class /).size
      end.sum
    end

    # The total number of modules defined.
    #
    # Returns an Integer.
    def modules_count
      project.file_contents.map do |file|
        file.scan(/module /).size
      end.sum
    end
  end
end