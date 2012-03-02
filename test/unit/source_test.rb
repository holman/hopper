require File.expand_path("../../helper", __FILE__)

context "Source" do
  setup do
    @source = Source.new('')
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
      @source.clone_url
    end
  end

  test "clone_command raises exception" do
    assert_raise Source::NotImplementedError do
      @source.clone_command
    end
  end

  test "clone_command! runs clone_command" do
    @source.expects(:clone_command).returns('clone-stub')
    @source.expects(:exec).with('clone-stub').returns(true)
    assert @source.clone_command!
  end
end