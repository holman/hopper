require File.expand_path("../../helper", __FILE__)

context "Tabs" do
  setup do
    fixture :simple
  end

  test "tabs_count" do
    assert_equal 3, @probe.tabs_count
  end

  test "two_spaces_count" do
    assert_equal 71, @probe.two_spaces_count
  end

  test "four_spaces_count" do
    assert_equal 19, @probe.four_spaces_count
  end

  test "tabs_used" do
    assert_equal 0, @probe.tabs_used
  end
end