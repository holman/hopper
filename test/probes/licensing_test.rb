require File.expand_path("../../helper", __FILE__)

context "Licensing" do
  setup do
    fixture :simple

    @project = Project.new('github.com')
    @probe = Licensing.new(@project)

    @probe.stubs(:revision).returns('a965377486e0ad522f639bc2b4bcaa1032f92565')
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

  test "bsd" do
    assert_equal 0, @probe.bsd
  end
end