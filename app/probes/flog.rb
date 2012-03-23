module Hopper
  class Flog < Probe
    exposes :method_average

    # The description.
    #
    # Returns a String.
    def description
      "Runs flog against code."
    end

    # The average flog score of each method.
    #
    # Returns an Integer.
    def method_average
      `cd #{project.path} && find . -name '\*.rb' |
       xargs flog -cm |
       sed -n 2p |
       tr ":", "\n" |
       sed -n 1p`.strip.to_f
    end
  end
end