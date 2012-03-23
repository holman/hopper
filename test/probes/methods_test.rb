require File.expand_path("../../helper", __FILE__)

context "Methods" do
  setup do
    fixture :simple

    @project = Project.new('github.com')
    @probe = Methods.new(@project)
  end

  test "class_count" do
    assert_equal 1, @probe.class_count
  end

  test "instance_count" do
    assert_equal 1, @probe.instance_count
  end

  test "method_name_length" do
    assert_equal 6.5, @probe.method_name_length
  end
end