require File.expand_path("../../helper", __FILE__)

context "README" do
  setup do
    @project = Project.new('github.com')
    @probe = Readme.new(@project)
  end

  test "description" do
    assert_match "READMEs", @probe.description
  end

  test "count" do
    assert_equal 1, @probe.count
  end

  test "markdown_format_count" do
    assert_equal 1, @probe.markdown_format_count
  end
end