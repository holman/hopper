module Hopper
  class Tabs < Probe
    # The data for this Probe.
    exposes :tabs_count, :two_spaces_count, :four_spaces_count

    # TODO: expose tabs_used?

    # The description.
    #
    # Returns a String.
    def description
      "Investigates the age-old question of hard or soft tabs."
    end

    # The total number of tabs in the project.
    #
    # Returns an Integer.
    def tabs_count
      project.file_contents.map do |file|
        file.scan(/\t/).size
      end.sum
    end

    # The total number of two-spaced soft tabs in the project.
    #
    # Returns an Integer.
    def two_spaces_count
      project.file_contents.map do |file|
        file.scan(/  /).size
      end.sum
    end

    # The total number of four-spaced soft tabs in the project.
    #
    # Returns an Integer.
    def four_spaces_count
      project.file_contents.map do |file|
        file.scan(/    /).size
      end.sum
    end

    # Does the project use tabs?
    #
    # Returns an Integer.
    def tabs_used?
      tabs_count > 0 && tabs_count > two_spaces_count
    end
  end
end