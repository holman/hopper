require File.expand_path("../../helper", __FILE__)

context "Loc" do
  setup do
    fixture :simple

    @project = Project.new('github.com')
    @probe = Loc.new(@project)

    @probe.stubs(:revision).returns('a965377486e0ad522f639bc2b4bcaa1032f92565')
  end

  test "data" do
    assert !@probe.data.keys.empty?
  end

  test "all lines" do
    assert_equal 69, @probe.lines
  end

  test "ruby lines" do
    assert_equal 14, @probe.ruby_lines
  end

  test "comment lines" do
    assert_equal 4, @probe.comment_lines
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