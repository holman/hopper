require File.expand_path("../../helper", __FILE__)

context "Swearing" do
  setup do
    @project = Project.new('github.com')
    @probe = Swearing.new(@project)
  end

  test "count" do
    assert_equal 1, @probe.word_count
  end
end