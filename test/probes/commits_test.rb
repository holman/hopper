require File.expand_path("../../helper", __FILE__)

context "Commits" do
  setup do
    fixture :simple

    @project = Project.new('github.com')
    @probe = Commits.new(@project)
  end

  test "total_count" do
    assert_equal 1, @probe.total_count
  end

  test "birthday" do
    assert_equal 2, @probe.birthday.month
  end
end