module Hopper
  class Flay < Probe
    exposes :total_score

    # The description.
    #
    # Returns a String.
    def self.description
      "Runs flay against code."
    end

    # The average flay score of each method.
    #
    # Returns an Integer.
    def total_score
      `cd #{project.path} && find . -name '\*.rb' |
       xargs flay -s |
       sed -n 2p |
       tr "=", "\n" |
       sed -n 1p`.strip.to_f
    end
  end
end