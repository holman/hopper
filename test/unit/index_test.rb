require File.expand_path("../../helper", __FILE__)

context "Index" do
  setup do
  end

  test "adding to the queue" do
    Index.queue 'https://github.com/holman'
    Index.queue 'https://github.com/defunkt'

    assert_equal 0, Index.all.count
    assert_equal 2, Index.pending.count
  end

  test "adding to the queue" do
    Index.add 'https://github.com/holman'
    Index.add 'https://github.com/defunkt'

    assert_equal 2, Index.all.count
    assert_equal 0, Index.pending.count
  end

  test "queuing one" do
    url = 'https://github.com/holman'
    Index.queue url

    assert_equal url, Index.next
    assert_equal nil, Index.next
  end
end