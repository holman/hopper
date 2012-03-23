require File.expand_path("../../helper", __FILE__)

context "Gemspecs" do
  setup do
    @project = Project.new('github.com')
    @probe = Gemspecs.new(@project)
  end

  test "present" do
    assert_equal 1, @probe.present
  end
end