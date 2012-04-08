module Hopper
  class Tabs < Probe
    # The data for this Probe.
    exposes :tabs_count, :two_spaces_count, :four_spaces_count, :tabs_used

    # TODO: expose tabs_used?

    # The description.
    #
    # Returns a String.
    def self.description
      "Investigates the age-old question of hard or soft tabs."
    end

    # The total number of tabs in the project.
    #
    # Returns an Integer.
    def tabs_count
      repository.files.map do |file|
        content = repository.read(file)
        content ? content.scan(/\t/).size : 0
      end.sum
    end

    # The total number of two-spaced soft tabs in the project.
    #
    # Returns an Integer.
    def two_spaces_count
      repository.files.map do |file|
        content = repository.read(file)
        content ? content.scan(/  /).size : 0
      end.sum
    end

    # The total number of four-spaced soft tabs in the project.
    #
    # Returns an Integer.
    def four_spaces_count
      repository.files.map do |file|
        content = repository.read(file)
        content ? content.scan(/    /).size : 0
      end.sum
    end

    # Does the project use tabs?
    #
    # Returns an Integer.
    def tabs_used
      result = tabs_count > 0 && tabs_count > two_spaces_count
      result ? 1 : 0
    end
  end
end