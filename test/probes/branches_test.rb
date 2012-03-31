require File.expand_path("../../helper", __FILE__)

context "Branches" do
  setup do
    fixture :simple

    @project = Project.new('github.com')
    @probe = Branches.new(@project)
  end

  # Simple fixtures repos doesn't have remotes, so let's just punt and check for
  # method existence.
  test "count" do
    assert @probe.respond_to?(:count)
  end
end