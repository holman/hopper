require File.expand_path("../../helper", __FILE__)

context "Tabs" do
  setup do
    fixture :simple

    @project = Project.new('github.com')
    @probe = Tabs.new(@project)

    @probe.stubs(:revision).returns('a965377486e0ad522f639bc2b4bcaa1032f92565')
  end

  test "tabs_count" do
    assert_equal 3, @probe.tabs_count
  end

  test "two_spaces_count" do
    assert_equal 65, @probe.two_spaces_count
  end

  test "four_spaces_count" do
    assert_equal 18, @probe.four_spaces_count
  end

  test "tabs_used" do
    assert_equal 0, @probe.tabs_used
  end
end