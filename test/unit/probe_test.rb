require File.expand_path("../../helper", __FILE__)

context "Probe" do
  setup do
    @project = Project.new('github.com')
  end

  test "list probes" do
    assert Probe.all.include?('loc')
    assert Probe.all.include?('swearing')
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