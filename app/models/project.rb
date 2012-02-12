module Hopper
  # A collection of code that we grab from somewhere. This is our common
  # interface for manipulating the project itself once we have it locally.
  class Project
    # The relative URL of this project.
    #
    # Returns a String.
    attr_accessor :url

    # Initializes a new Project.
    #
    # path - The String path to this project.
    def initialize(url)
      @url = url
    end

    # The path to this project on-disk.
    #
    # Returns a String.
    def path
      'stub'
    end
  end
end