require File.expand_path("../../helper", __FILE__)

context "Loc" do
  setup do
    fixture :simple
  end

  test "data" do
    assert !@probe.data.keys.empty?
  end

  test "all lines" do
    assert_equal 78, @probe.lines
  end

  test "ruby lines" do
    assert_equal 19, @probe.ruby_lines
  end

  test "comment lines" do
    assert_equal 5, @probe.comment_lines
  end

  test "average_width" do
    @probe.stubs(:widths).returns([0,50,100])
    assert_equal 50, @probe.average_width
  end

  test "percent_80c" do
    @probe.stubs(:widths).returns([10,90,25,0])
    assert_equal 0.25, @probe.percent_80c
  end
end
