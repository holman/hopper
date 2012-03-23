require File.expand_path("../../helper", __FILE__)

context "Flog" do
  setup do
    @project = Project.new('github.com')
    @probe = Hopper::Flog.new(@project)
  end

  test "method_average" do
    assert_equal 3.6, @probe.method_average
  end
end