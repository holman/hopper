class Array
  # Sums up an array.
  #
  # Examples:
  #   [1,3,6].sum # => 10
  #
  # Returns an Integer.
  def sum
    self.inject(0) { |sum,i| sum + i }
  end

  # Average out the values of a collection of Arrays. The array gets flattened,
  # so you can safely toss it a stack of Arrays.
  #
  # Examples:
  #   [[2,4],[6],8] # => 5
  #
  # Returns a Float.
  def average
    self.flatten!
    self.sum / self.size
  end
end