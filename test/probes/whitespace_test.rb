require File.expand_path("../../helper", __FILE__)

context "Whitespace" do
  setup do
    fixture :simple
  end

  test "trailing_count" do
    assert_equal 2, @probe.trailing_count
  end

  test "trailing_percent" do
    assert_equal "0.02564102564102564", @probe.trailing_percent.to_s
  end
end
