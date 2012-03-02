require File.expand_path("../../helper", __FILE__)

context "Source" do
  setup do
  end

  test "name raises exception" do
    assert_raise Source::NotImplementedError do
      Source.name
    end
  end

  test "url raises exception" do
    assert_raise Source::NotImplementedError do
      Source.url
    end
  end

  test "clone_url raises exception" do
    assert_raise Source::NotImplementedError do
      Source.new('').clone_url
    end
  end
end