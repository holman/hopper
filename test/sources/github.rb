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

  test "clone_url" do
    assert_match "https://github.com/holman/hopper.git", @source.clone_url
  end
end