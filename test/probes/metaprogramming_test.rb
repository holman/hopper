require File.expand_path("../../helper", __FILE__)

context "Metaprogramming" do
  setup do
    fixture :simple

    @project = Project.new('github.com')
    @probe = Metaprogramming.new(@project)

    @probe.stubs(:revision).returns('a965377486e0ad522f639bc2b4bcaa1032f92565')
  end

  test "define_method_count" do
    assert_equal 0, @probe.define_method_count
  end

  test "send_count" do
    assert_equal 1, @probe.send_count
  end
end