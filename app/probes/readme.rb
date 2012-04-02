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
      project.files.collect do |file|
        File.basename(file).match(/readme/i) ? 1 : 0
      end.sum
    end

    # How many READMEs are in Markdown format?
    #
    # Returns an Integer.
    def markdown_format_count
      readmes.select do |file|
        %w(.md .markdown .mdown .markd .mkd).include?(File.extname(file.chomp).downcase)
      end.count
    end

  private
    def readmes
      `ls #{project.path} | grep -i readme`
    end
  end
end