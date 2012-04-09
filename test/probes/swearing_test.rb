require File.expand_path("../../helper", __FILE__)

context "Swearing" do
  setup do
    fixture :simple
  end

  test "count" do
    assert_equal 1, @probe.word_count
  end
end