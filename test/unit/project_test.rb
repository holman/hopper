require File.expand_path("../../helper", __FILE__)

context "Project" do
  setup do
    @project = Project.new('stub')
  end

  test "path" do
    assert_equal 'test/examples/simple', @project.path
  end

  test "files" do
    app    = File.join(@project.path, 'app.rb')
    readme = File.join(@project.path, 'README.md')
    assert_equal [app,readme], @project.files
  end

  test "analyze!" do
    Probe.expects(:analyze!).returns(true)
    assert @project.analyze!
  end
end