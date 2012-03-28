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
    assert_equal 3, @probe.birthday.month
  end

  test "commits_per_day" do
    @probe.stubs(:days_old).returns(10)
    @probe.stubs(:total_count).returns(50)
    assert_equal 5, @probe.commits_per_day
  end

  test "days_old" do
    from = Date.parse('2012-01-15')
      to = Date.parse('2012-01-18')

    @probe.stubs(:birthday).returns(from)

    assert_equal 3, @probe.days_old(to)
  end
end