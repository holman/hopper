require File.expand_path("../../helper", __FILE__)

context "App" do
  setup do
  end

  test "/" do
    get "/"
    assert_match "Hopper", last_response.body.strip
  end

  test "/stats" do
    get "/stats"
    assert_match "Stats", last_response.body.strip
  end

  test "/probes" do
    get "/probes"
    assert_match "Probes", last_response.body.strip
  end

  test "/projects" do
    get "/projects"
    assert_match "projects", last_response.body.strip
  end

  test "/projects/:id" do
    project = Project.new('github.com/holman/play')
    project.save
    get "/projects/#{project.id}"
    assert_match 'holman/play', last_response.body.strip
  end

  test '/projects/jump' do
    project = Project.new('github.com/holman/play')
    project.save
    get "/projects/jump", :url => 'https://github.com/holman/play'

    assert last_response.redirect?
    assert_match "/projects/#{project.id}", last_response.location
  end

  test '/projects/jump (with non-existent project url)' do
    get "/projects/jump", :url => 'https://github.com/non/existent'

    assert last_response.redirect?
    assert_match "/projects", last_response.location
  end
end