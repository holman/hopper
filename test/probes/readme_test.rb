require File.expand_path("../../helper", __FILE__)

context "Readme" do
  setup do
    fixture :simple
  end

  test "count" do
    assert_equal 1, @probe.count
  end

  test "markdown_format_count" do
    assert_equal 1, @probe.markdown_format_count
  end
end