require File.expand_path("../../helper", __FILE__)

context "Contributors" do
  setup do
    fixture :simple
  end

  test "contributors_count" do
    assert_equal 1, @probe.contributors_count
  end

  test "contributors" do
    assert_equal 'Zach Holman', @probe.contributors['zach@zachholman.com'][:author]
    assert 0 < @probe.contributors['zach@zachholman.com'][:count]
  end
end