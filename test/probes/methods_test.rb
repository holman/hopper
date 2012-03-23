require File.expand_path("../../helper", __FILE__)

context "Methods" do
  setup do
    @project = Project.new('github.com')
    @probe = Methods.new(@project)
  end

  test "class_count" do
    assert_equal 1, @probe.class_count
  end

  test "instance_count" do
    assert_equal 1, @probe.instance_count
  end
end