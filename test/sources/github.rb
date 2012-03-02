require File.expand_path("../../helper", __FILE__)

context "Github" do
  setup do
    @source = Github.new
  end

  test "name" do
    assert_match "GitHub", Github.name
  end

  test "url" do
    assert_match "https://github.com", Github.url
  end
end