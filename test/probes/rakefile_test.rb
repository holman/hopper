require File.expand_path("../../helper", __FILE__)

context "Rakefile" do

  setup do
    fixture :files

    @project = Project.new('github.com')
    @probe = Hopper::Rakefile.new(@project)

    @probe.stubs(:revision).returns('f46243f23d75b699eee5b586ab884a034dee2638')
  end

  test "rakefile_present" do
    assert_equal 1, @probe.rakefile_present
  end

  test "default_task" do
    assert_equal :test, @probe.default_task
  end
end