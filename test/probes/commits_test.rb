require File.expand_path("../../helper", __FILE__)

context "Commits" do
  setup do
    fixture :simple
  end

  test "total_count" do
    @probe.total_count # calling it twice to avoid segfaults on ruby_parser
    assert_equal 7, @probe.total_count
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
    from = Time.at(1333523564)
      to = Time.at(1333782764)

    @probe.stubs(:birthday).returns(from)

    assert_equal 3, @probe.days_old(to)
  end

  test "emojis_count" do
    assert_equal 2, @probe.emojis_count
  end
end
