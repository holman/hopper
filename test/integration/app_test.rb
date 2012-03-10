require File.expand_path("../../helper", __FILE__)

context "App" do
  setup do
  end

  test "/" do
    get "/"
    assert_match "Hopper", last_response.body.strip
  end

  test "/projects" do
    get "/projects"
    assert_match "projects", last_response.body.strip
  end
end