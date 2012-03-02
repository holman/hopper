require File.expand_path("../../helper", __FILE__)

context "Github" do
  setup do
    @source = Github.new('https://github.com/holman/hopper')
  end

  test "source name" do
    assert_match "GitHub", Github.name
  end

  test "source url" do
    assert_match "https://github.com", Github.url
  end

  test "name" do
    assert_match "holman/hopper", @source.name
  end

  test "clone_url" do
    assert_match "https://github.com/holman/hopper.git", @source.clone_url
  end

  test "directory_name" do
    assert_equal "holman-hopper", @source.directory_name
  end

  test "local_path" do
    assert_equal "tmp/holman-hopper", @source.local_path
  end
end