require File.expand_path("../../helper", __FILE__)

context "Source" do
  setup do
    @source = Source.new
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
end