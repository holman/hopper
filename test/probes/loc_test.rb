require File.expand_path("../../helper", __FILE__)

context "Loc" do
  setup do
    @project = Project.new('github.com')
    @probe = Loc.new(@project)
  end

  test "description" do
    assert_match "lines of code", @probe.description
  end

  test "data" do
    assert !@probe.data.keys.empty?
  end

  test "all lines" do
    assert_equal 38, @probe.lines
  end

  test "ruby lines" do
    assert_equal 14, @probe.ruby_lines
  end

  test "comment lines" do
    assert_equal 4, @probe.comment_lines
  end
end