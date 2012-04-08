module Hopper
  # A collection of metrics designed to investigate status of READMEs in a
  # particular project.
  class Readme < Probe
    # The data for this Probe.
    exposes :count, :markdown_format_count

    # The description.
    #
    # Returns a String.
    def self.description
      "READMEs in a Project."
    end

    # The count of all READMEs in this project.
    #
    # Returns an Integer.
    def count
      repository.files.map do |file|
        file.match(/readme/i) ? 1 : 0
      end.sum
    end

    # How many READMEs are in Markdown format?
    #
    # Returns an Integer.
    def markdown_format_count
      repository.files.map do |file|
        if file.match(/readme/i)
          %w(.md .markdown .mdown .markd .mkd).map do |ext|
            file.match(/#{ext}/) ? 1 : 0
          end.sum
        else
          0
        end
      end.sum
    end
  end
end