require File.expand_path("../../helper", __FILE__)

context "Containers" do
  setup do
    fixture :files

    @project = Project.new('github.com')
    @probe = Containers.new(@project)
  end

  test "classes_count" do
    assert_equal 1, @probe.classes_count
  end

  test "modules_count" do
    assert_equal 2, @probe.modules_count
  end

  test "multiple_per_file" do
    assert_equal 1, @probe.multiple_per_file
  end
end