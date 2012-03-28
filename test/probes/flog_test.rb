require File.expand_path("../../helper", __FILE__)

context "Flog" do
  setup do
    fixture :simple

    @project = Project.new('github.com')
    @probe = Hopper::Flog.new(@project)
  end

  test "method_average" do
    assert_equal '3.6', @probe.method_average.to_s
  end
end