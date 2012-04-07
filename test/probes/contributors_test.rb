require File.expand_path("../../helper", __FILE__)

context "Contributors" do
  setup do
    fixture :simple

    @project = Project.new('github.com/holman/hopper')
    @probe = Contributors.new(@project)

    @probe.stubs(:revision).returns('011fa5546dccb754c9afa000e239d6e31fcc6819')
  end

  test "contributors_count" do
    assert_equal 1, @probe.contributors_count
  end

  test "contributors" do
    assert_equal 'Zach Holman', @probe.contributors['zach@zachholman.com'][:author]
    assert 0 < @probe.contributors['zach@zachholman.com'][:count]
  end
end