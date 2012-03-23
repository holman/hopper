require File.expand_path("../../helper", __FILE__)

context "Array" do
  test "sum" do
    assert_equal 10, [1,3,6].sum
  end

  test "average" do
    assert_equal  5, [2,4,6,8].average
    assert_equal 20, [10,[20],[20],[[30]]].average
  end
end