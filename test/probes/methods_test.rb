require File.expand_path("../../helper", __FILE__)

context "Methods" do
  setup do
    fixture :simple
  end

  test "class_count" do
    assert_equal 1, @probe.class_count
  end

  test "instance_count" do
    assert_equal 2, @probe.instance_count
  end
end