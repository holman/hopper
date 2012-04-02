module Hopper
  class Flog < Probe
    exposes :method_average

    # The description.
    #
    # Returns a String.
    def self.description
      "Runs flog against code."
    end

    # The average flog score of each method.
    #
    # Returns an Integer.
    def method_average
      flog = ::Flog.new
      flog.flog(files)
      flog.average
    end

  private
    def files
      Dir.glob("#{project.path}/**/*.rb")
    end
  end
end