module Hopper
  # A collection of metrics designed to investigate status of READMEs in a
  # particular project.
  class Readme < Probe
    # The data for this Probe.
    exposes :count

    # The description.
    #
    # Returns a String.
    def description
      "READMEs in a Project."
    end

    # The count of all READMEs in this project.
    #
    # Returns an Integer.
    def count
      project.files.collect do |file|
        File.basename(file).match(/readme/i) ? 1 : 0
      end.sum
    end
  end
end