require File.expand_path("../../helper", __FILE__)

context "Popularity" do
  setup do
    fixture :simple
  end

  test "followers" do
    Github.any_instance.expects(:followers).returns(3)
    assert_equal 3, @probe.followers
  end

  test "contributors" do
    Github.any_instance.expects(:forks).returns(3)
    assert_equal 3, @probe.forks
  end

  test "contributors" do
    Github.any_instance.expects(:open_issues).returns(10)
    assert_equal 10, @probe.open_issues
  end
end