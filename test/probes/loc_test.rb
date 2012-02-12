require File.expand_path("../../helper", __FILE__)

context "Loc" do
  setup do
    @probe = Loc.new('test/examples/simple')
  end

  test "description" do
    assert_match "lines of code", @probe.description
  end

  test "files" do
    file = File.join(@probe.path, 'app.rb')
    assert_equal [file], @probe.files
  end

  test "lines" do
    assert_equal 10, @probe.lines
  end
end