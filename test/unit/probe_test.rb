require File.expand_path("../../helper", __FILE__)

context "Probe" do
  test "name" do
    assert_equal 'Probe', Probe.new.name
  end

  test "description raises exception" do
    assert_raise Probe::NotImplementedError do
      Probe.new.description
    end
  end
end