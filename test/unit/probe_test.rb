require File.expand_path("../../helper", __FILE__)

context "Probe" do
  setup do
    @project = Project.new('github.com/holman/play')
    @probe   = Probe.new(@project)
  end

  test "new defaults to head revision" do
    @project.expects(:head_revision).returns('deadbeef')
    probe = Probe.new(@project)
    assert_equal 'deadbeef', probe.revision
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
    @probe.expects(:clone).returns(true)

    hash = {:name => 'Probe'}
    @probe.save
    assert_equal hash, @probe.data
  end

  test "versioned_data" do
    Probe.exposes :a_count, :b_count
    results = @probe.versioned_data

    assert_equal 2, results.size
    assert_equal "A count", results.first.name
    assert_equal "B count", results.last.name
  end

  test "metrics" do
    Probe.exposes :count
    $redis.rpush "#{Probe.key}:count", 10
    $redis.rpush "#{Probe.key}:count", 30

    results = Probe.metrics

    assert_equal 1,       results.size
    assert_equal 'Count', results.first.name
    assert_equal 20,      results.first.mean
  end

  test "clean_probe_name" do
    assert_equal "Holman count", Probe.clean_probe_name(:holman_count)
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