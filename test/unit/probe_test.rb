require File.expand_path("../../helper", __FILE__)

context "Probe" do
  setup do
    @project = Project.new('github.com')
    @probe   = Probe.new(@project)
  end

  test "find" do
    assert 'Swearing', Probe.find('Swearing').name
  end

  test "all probes as constants" do
    assert Probe.all.include?(Hopper::Loc)
    assert Probe.all.include?(Hopper::Swearing)
  end

  test "class name" do
    assert_equal 'Probe', Probe.name
  end

  test "instance name" do
    assert_equal 'Probe', Probe.new(@project).name
  end

  test "exposes data" do
    Probe.exposes :name
    hash = {:name => 'Probe'}
    @probe.save
    assert_equal hash, @probe.data
  end

  test "save saves attributes" do
    Probe.exposes :name
    @probe.save
    assert_equal 'Probe', @probe.data[:name]
  end

  test "numeric_binary" do
    result = @probe.binary_integer(%w(one two three four))
    assert_equal 1, result

    result = @probe.binary_integer([])
    assert_equal 0, result
  end

  test "description raises exception" do
    assert_raise Probe::NotImplementedError do
      Probe.new(@project).description
    end
  end

  test "class description" do
    assert_raise Probe::NotImplementedError do
      Probe.description
    end
  end
end