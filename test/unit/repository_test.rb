require File.expand_path("../../helper", __FILE__)

context "Repository" do
  setup do
    @repo = Repository.new(:path => 'test/examples/simple',
                           :revision => 'b31672e80115575894f8ea767b02dd7b077ce86e')
  end

  def test_initialize
    repo = Repository.new(:path => 'test/examples/simple',
                          :revision => 'b31672e80115575894f8ea767b02dd7b077ce86e')

    assert_equal 'b31672e80115575894f8ea767b02dd7b077ce86e', repo.revision
    assert_equal 'test/examples/simple', repo.path
    assert repo.repo.kind_of?(Rugged::Repository)
    assert repo.tree.kind_of?(Rugged::Tree)
    assert repo.walker.kind_of?(Rugged::Walker)
  end

  def test_files
    assert_equal 5, @repo.files.size
  end

  def test_files_have_relative_path
    files = @repo.files.select{|file| file == 'test/simple_test.rb'}
    assert_equal 1, files.size
  end

  def test_files_can_take_a_filter
    files = @repo.files(:filter => /\.rb/)
    assert_equal 2, files.size
  end

  def test_can_read_files
    assert_match /the money, honey/,      @repo.read(:path => 'README.md')
    assert_match /should_test_something/, @repo.read(:path => 'test/simple_test.rb')
  end
end