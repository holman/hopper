module Hopper
  # A Source is a place where we can get a Project. Usually a version control
  # host.
  class Source
    # Load all sources.
    Dir["app/sources/*.rb"].each {|file| require file }

    # The name of the Source.
    #
    # Returns a String.
    def name
      raise NotImplementedError
    end

    # The main URL of the Source.
    #
    # Returns a String.
    def url
      raise NotImplementedError
    end

    # Raised if the method hasn't been properly defined in the subclass.
    class NotImplementedError < StandardError ; end
  end
end