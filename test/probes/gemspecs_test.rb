require File.expand_path("../../helper", __FILE__)

context "Gemspecs" do
  setup do
    fixture :simple

    @project = Project.new('github.com')
    @probe = Gemspecs.new(@project)

    @probe.stubs(:revision).returns('a965377486e0ad522f639bc2b4bcaa1032f92565')
  end

  test "present" do
    assert_equal 1, @probe.present
  end
end