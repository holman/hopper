require File.expand_path("../../helper", __FILE__)

context "App" do
  setup do
  end

  test "/" do
    get "/"
    assert_match "Hopper", last_response.body.strip
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
    project = Project.new('github.com/holman/hopper')
    Probe.all.each{|probe| probe.any_instance.stubs(:checkout_revision).returns(true)}
    project.save
    get "/projects/#{project.id}"
    assert_match 'holman/hopper', last_response.body.strip
  end
end