require File.expand_path("../../helper", __FILE__)

context "Contributors" do
  setup do
    fixture :simple

    @project = Project.new('github.com/holman/hopper')
    @probe = Contributors.new(@project)
  end

  test "contributors" do
    @probe.stubs(:revision).returns('011fa5546dccb754c9afa000e239d6e31fcc6819')
    assert_equal 'Zach Holman', @probe.contributors['zach@zachholman.com'][:author]
    assert 0 < @probe.contributors['zach@zachholman.com'][:count]
  end
end