module Hopper
  module Views
    class Aggregate < Layout
      attr_accessor :name
      attr_accessor :values

      def initialize(name,values)
        @name   = name
        @values = values
      end
    end
  end
end