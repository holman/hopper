require File.expand_path("../../helper", __FILE__)

context "Popularity" do
  setup do
    fixture :simple

    @project = Project.new('github.com/holman/hopper')
    @probe = Popularity.new(@project)
  end

  test "followers" do
    Github.any_instance.expects(:followers).returns(3)
    @probe.followers
  end

  test "contributors" do
    Github.any_instance.expects(:forks).returns(3)
    @probe.forks
  end
end