require File.expand_path("../../helper", __FILE__)

context "Probe" do
  setup do
    @project = Project.new('github.com')
  end

  test "all probes" do
    assert Probe.all.include?('loc')
    assert Probe.all.include?('swearing')
  end

  test "all probes as constants" do
    assert Probe.all_as_constants.include?(Hopper::Loc)
    assert Probe.all_as_constants.include?(Hopper::Swearing)
  end

  test "name" do
    assert_equal 'Probe', Probe.new(@project).name
  end

  test "description raises exception" do
    assert_raise Probe::NotImplementedError do
      Probe.new(@project).description
    end
  end
end