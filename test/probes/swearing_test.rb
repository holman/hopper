require File.expand_path("../../helper", __FILE__)

context "Swearing" do
  setup do
    fixture :simple
  end

  test "count" do
    assert_equal 1, @probe.word_count
  end

  test "commit_count" do
    assert_equal 3, @probe.commit_count
  end
end