module Hopper
  module Views
    class Stats < Layout
      def title
        "Indexed Projects"
      end

      def total
        Hopper::Project.all.length
      end

      def metrics
        Hopper::Project.all.length *
          10 * # Number of snapshots per repo
          Hopper::Probe.all.map{|probe| probe.exposed.length}.sum.to_i
      end
    end
  end
end