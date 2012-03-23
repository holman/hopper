module Hopper
  class Rakefile < Probe
    exposes :rakefile_present, :default_task

    # The description.
    #
    # Returns a String.
    def description
      "rake and Rakefiles."
    end

    # Is a Gemfile present in this project?
    #
    # Returns a binary integer.
    def rakefile_present
      binary_integer Dir.glob("#{project.path}/Rakefile")
    end

    # Try to glean what the default task is set to.
    #
    # Returns a String.
    def default_task
      file = File.read("#{project.path}/Rakefile")
      default = nil
      RubyParser.new.parse(file).each_of_type(:call) do |node|
        if node[2] == :task
          default ||= node.sexp_body[2].sexp_body.last.last.last
        end
      end
      default
    end
  end
end