require File.expand_path("../../helper", __FILE__)

context "Bundler" do

  setup do
    fixture :files

    @project = Project.new('github.com')
    @probe = Hopper::Bundler.new(@project)
  end

  test "gemfile_present" do
    assert_equal 1, @probe.gemfile_present
  end

  test "gemfile_lock_present" do
    assert_equal 0, @probe.gemfile_lock_present
  end

  test "gems_used" do
    assert_equal 3, @probe.gems_used
  end
end