require File.expand_path("../../helper", __FILE__)

context "Swearing" do
  setup do
    fixture :simple

    @project = Project.new('github.com')
    @probe = Swearing.new(@project)

    @probe.stubs(:revision).returns('a965377486e0ad522f639bc2b4bcaa1032f92565')
  end

  test "count" do
    assert_equal 1, @probe.word_count
  end
end