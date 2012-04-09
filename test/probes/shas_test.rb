require File.expand_path("../../helper", __FILE__)

context "Shas" do
  setup do
    fixture :simple
  end

  test "longest_string" do
    assert_equal 'dccb', @probe.longest_string
  end

  test "longest_string_length" do
    assert_equal 4, @probe.longest_string_length
  end

  test "longest_integer" do
    assert_equal 80115575894, @probe.longest_integer
  end

  test "longest_integer_length" do
    assert_equal 11, @probe.longest_integer_length
  end
end