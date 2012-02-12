require File.expand_path("../../helper", __FILE__)

context "Loc" do
  setup do
    @probe = Loc.new('test/examples/simple')
  end

  test "description" do
    assert_match "lines of code", @probe.description
  end

  test "files" do
    app    = File.join(@probe.path, 'app.rb')
    readme = File.join(@probe.path, 'README.md')
    assert_equal [app,readme], @probe.files
  end

  test "all lines" do
    assert_equal 13, @probe.lines
  end

  test "ruby lines" do
    assert_equal 10, @probe.ruby_lines
  end
end