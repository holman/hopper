require File.expand_path("../../helper", __FILE__)

context "Contributors" do
  setup do
    @project = Project.new('github.com')
    @probe = Contributors.new(@project)
  end

  test "total_count" do
    assert_equal 1, @probe.total_count
  end

  test "contributors" do
    assert_equal 'Zach Holman',         @probe.contributors.first[:author]
    assert_equal 'zach@zachholman.com', @probe.contributors.first[:email]
    assert 0 < @probe.contributors.first[:count]
  end
end