require File.expand_path("../../helper", __FILE__)

context "Array" do
  test "sum" do
    assert_equal 10, [1,3,6].sum
  end
end