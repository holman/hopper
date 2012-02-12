require File.expand_path("../../helper", __FILE__)

context "Loc" do
  test "description" do
    assert_match "lines of code", Loc.new.description
  end
end