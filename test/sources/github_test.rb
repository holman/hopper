require File.expand_path("../../helper", __FILE__)

context "Github" do
  setup do
    fixture :simple
    @source = Github.new('github.com/holman/play')
  end

  test "indexing?" do
    assert !Github.indexing?
  end

  test "indexing" do
    Github.indexing(true)
    assert Github.indexing?
    Github.indexing(false)
    assert !Github.indexing?
  end

  test "source name" do
    assert_match "GitHub", Github.name
  end

  test "source url" do
    assert_match "https://github.com", Github.url
  end

  test "name" do
    assert_match "holman/play", @source.name
  end

  test "clone_url" do
    assert_match "https://github.com/holman/play.git", @source.clone_url
  end

  test "directory_name" do
    assert_equal "holman-play", @source.directory_name
  end

  test "local_path" do
    assert_equal "test/examples/simple", @source.local_path
  end
end