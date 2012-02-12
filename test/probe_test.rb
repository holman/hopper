require File.expand_path("../helper", __FILE__)

context "App" do
  test "/" do
    get "/"

    assert_equal "Hopper", last_response.body
  end
end