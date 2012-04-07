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

  test "name raises exception" do
    assert_raise Source::NotImplementedError do
      @source.name
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

  test "clone runs clone_command" do
    @source.expects(:local_path).returns('nonexistent')
    @source.expects(:clone_command).returns('clone-stub')
    @source.expects(:system).with('clone-stub').returns(true)
    assert @source.clone
  end
end