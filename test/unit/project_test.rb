require File.expand_path("../../helper", __FILE__)

context "Project" do
  setup do
    clean
    @project = Project.new('stub')
  end

  test "path" do
    assert_equal 'stub', @project.path
  end
end