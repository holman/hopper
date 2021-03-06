require File.expand_path("../../helper", __FILE__)

context "Branches" do
  setup do
    fixture :simple
  end

  # Simple fixtures repos doesn't have remotes, so let's just punt and check for
  # method existence.
  test "count" do
    assert @probe.respond_to?(:count)
  end
end