require File.expand_path("../../helper", __FILE__)

context "Metaprogramming" do
  setup do
    @project = Project.new('github.com')
    @probe = Metaprogramming.new(@project)
  end

  test "define_method_count" do
    assert_equal 0, @probe.define_method_count
  end

  test "send_count" do
    assert_equal 1, @probe.send_count
  end
end