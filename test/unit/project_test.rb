require File.expand_path("../../helper", __FILE__)

context "Project" do
  setup do
    @project = Project.new('github.com/holman/hopper')
  end

  test "initializes" do
    project = Project.new('github.com/holman/boom')
    project.id = 'f40942d357a7df851462c52b15328250ae103879'
    project.url = 'github.com/holman/boom'
  end

  test "url saves without protocol" do
    @project.url = 'https://github.com/holman/boom'
    assert_equal 'github.com/holman/boom', @project.url

    @project.url = 'http://github.com/holman/boom'
    assert_equal 'github.com/holman/boom', @project.url
  end

  test "url saves without www" do
    @project.url = 'www.github.com/holman/boom'
    assert_equal 'github.com/holman/boom', @project.url
  end

  test "path" do
    assert_equal 'test/examples/simple', @project.path
  end

  test "files" do
    app     = File.join(@project.path, 'app.rb')
    gemspec = File.join(@project.path, 'example.gemspec')
    readme  = File.join(@project.path, 'README.md')
    license = File.join(@project.path, 'LICENSE')
    assert_equal [app,gemspec,license,readme], @project.files
  end

  test "analyze" do
    Github.any_instance.expects(:clone).returns(true)
    Probe.expects(:analyze).returns(true)
    assert @project.analyze
  end

  test "sha1" do
    @project.url = 'github.com/holman/boom'
    assert_equal 'f40942d357a7df851462c52b15328250ae103879', @project.sha1
  end

  test "source" do
    assert_equal "GitHub", @project.source.class.name
  end

  test "save" do
    @project.expects(:async_analyze).returns(true)

    assert_equal 0, Project.all.count
    @project.save

    assert_equal 1, Project.all.count
  end

  test "all" do
    @project.save
    assert_equal 1, Project.all.count
  end

  test "create" do
    project = Project.create('github.com/holman/hopper')
    assert_equal 1, Project.all.count
  end

  test "find" do
    @project.save
    assert_equal @project.url, Project.find(@project.id).url
  end
end