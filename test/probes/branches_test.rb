require File.expand_path("../../helper", __FILE__)

context "Branches" do
  setup do
    fixture :simple

    @project = Project.new('github.com')
    @probe = Branches.new(@project)
  end

  test "count" do
    assert_equal 2, @probe.count
  end
end