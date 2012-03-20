require File.expand_path("../../helper", __FILE__)

context "Licensing" do
  setup do
    @project = Project.new('github.com')
    @probe = Licensing.new(@project)
  end

  test "present" do
    assert_equal 1, @probe.present
  end

  test "mit" do
    assert_equal 1, @probe.mit
  end

  test "gpl" do
    assert_equal 0, @probe.gpl
  end

  test "lgpl" do
    assert_equal 0, @probe.gpl
  end

  test "apache" do
    assert_equal 0, @probe.gpl
  end
end