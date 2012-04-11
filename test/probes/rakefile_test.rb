require File.expand_path("../../helper", __FILE__)

context "Rakefile" do

  setup do
    fixture :files
  end

  test "rakefile_present" do
    assert_equal 1, @probe.rakefile_present
  end
end