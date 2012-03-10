class Array
  # Sums up an array.
  #
  # Examples:
  #   [1,3,6].sum #=> 10
  #
  # Returns an Integer.
  def sum
    self.inject(0) { |sum,i| sum + i }
  end
end