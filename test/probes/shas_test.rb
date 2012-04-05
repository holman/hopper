require File.expand_path("../../helper", __FILE__)

context "Shas" do
  setup do
    fixture :simple

    @project = Project.new('github.com')
    @probe = Shas.new(@project)
    @probe.stubs(:revision).returns('011fa5546dccb754c9afa000e239d6e31fcc6819')
  end

  test "longest_string" do
    assert_equal 'dccb', @probe.longest_string
  end

  test "longest_string_length" do
    assert_equal 4, @probe.longest_string_length
  end

  test "longest_integer" do
    assert_equal 6819, @probe.longest_integer
  end

  test "longest_integer_length" do
    assert_equal 4, @probe.longest_integer_length
  end
end