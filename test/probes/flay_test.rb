require File.expand_path("../../helper", __FILE__)

context "Flay" do
  setup do
    @project = Project.new('github.com')
    @probe = Hopper::Flay.new(@project)
  end

  test "total_score" do
    assert_equal 0, @probe.total_score
  end
end