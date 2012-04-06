require File.expand_path("../../helper", __FILE__)

context "Project" do
  setup do
    @project = Project.new('github.com/holman/hopper')
  end

  test "initializes" do
    project = Project.new('github.com/holman/boom')
    project.id = 'f40942d357a7df851462c52b15328250ae103879'
    project.url = 'github.com/holman/boom'
  end

  test "key" do
    assert !Project.key.empty?
  end

  test "head key" do
    assert !@project.head_key.empty?
  end

  test "snapshots key" do
    assert !@project.snapshots_key.empty?
  end

  test "url saves without protocol" do
    @project.url = 'https://github.com/holman/boom'
    assert_equal 'github.com/holman/boom', @project.url

    @project.url = 'http://github.com/holman/boom'
    assert_equal 'github.com/holman/boom', @project.url
  end

  test "url saves without www" do
    @project.url = 'www.github.com/holman/boom'
    assert_equal 'github.com/holman/boom', @project.url
  end

  test "path" do
    assert_equal 'test/examples/simple', @project.path
  end

  test "files" do
    app     = File.join(@project.path, 'app.rb')
    gemspec = File.join(@project.path, 'example.gemspec')
    readme  = File.join(@project.path, 'README.md')
    license = File.join(@project.path, 'LICENSE')
    assert_equal [app,gemspec,license,readme], @project.files
  end

  test "analyze" do
    Github.any_instance.expects(:clone).returns(true)
    Probe.expects(:analyze).returns(true)
    @project.expects(:snapshots!).returns(true)
    assert @project.analyze
  end

  test "versioned_probes" do
    @project.stubs(:snapshots).returns(%w(sha1 sha2 sha3))

    versioned = @project.versioned_probes
    probes = Dir.glob("app/probes/*.rb")

    assert_equal probes.size, versioned.size
    assert_equal 3, versioned.first.probes.size
  end

  test "versioned_probe" do
    @project.stubs(:snapshots).returns(%w(sha1 sha2 sha3))
    @project.stubs(:head_revision).returns('sha1')
    Tabs.any_instance.stubs(:checkout_revision).returns(true)

    versioned = @project.versioned_probe(Tabs)

    assert_equal 3, versioned.size
  end

  test "sha1" do
    @project.url = 'github.com/holman/boom'
    assert_equal 'f40942d357a7df851462c52b15328250ae103879', @project.sha1
  end

  test "snapshots (all)" do
    shas = "a44ddf72959a9fc3944802e3dce422ad55e68e46
            1d970d29256b8e937f5f6492fffe9b163cb023d5
            80d3cae44722468b80e829928f8ee1d1c142485f
            aad7d9ab97d16ed154b5c4e76bfe263114a4968d
            314b1708a8b063d3cf762383a89e6707b06539ad"
    array = shas.split("\n").map{|sha| sha.strip}

    Github.any_instance.expects(:revisions).returns(shas)
    Github.any_instance.expects(:commit_count).returns(5)
    @project.snapshots!

    assert_equal 5,           @project.snapshots.size
    assert_equal array,       @project.snapshots
    assert_equal array.first, @project.head_revision
  end

  test "snapshots (selection)" do
    shas =   "9349dbc3aa2eaee73c7c44f07c561bb6e53805a2
              b001af06418444dde380d033f1b15dc53b2fc23f
              ca5ee43ae7a0359131f0b257d0cc015d2a21f17c
              b30a635cae53b257c06b11a5528df6c44bf326c0
              3f91b3afe1f9968211303f5d1ab2e9299e710d4a
              78470c151fc4c32879e92d3cf88000dcb24d02cf
              665ac842f263242d31bd586d18658014dfd7b215
              34436076c024bab9f37df902bf3d874424c87fcc
              6f48acc73e1b4e483683ca7b5642085f2c17da4d
              14b0541b9993e8ed6b309e47d678fda0fa2f2962
              26dd74f01b267c89814bca548286c476bfca7405
              4964ed795904bb97603f5e0a79b1b0524a8650d5
              5dfafb13bfd6a2bb52a3938be7fbaade1c3baa55
              0e605471af4c383864614c09ac2a5902566a366d
              e96e00aed1eba517e02a34fae6231bc7bb32a9cf
              69a83282b9ad7b1bbc5c103fa5df260a60d25a83
              1d662490df3153fdac5ed3638f1d022b88283225
              a44ddf72959a9fc3944802e3dce422ad55e68e46
              1d970d29256b8e937f5f6492fffe9b163cb023d5
              80d3cae44722468b80e829928f8ee1d1c142485f
              aad7d9ab97d16ed154b5c4e76bfe263114a4968d
              314b1708a8b063d3cf762383a89e6707b06539ad"

    array = %w(
              9349dbc3aa2eaee73c7c44f07c561bb6e53805a2
              ca5ee43ae7a0359131f0b257d0cc015d2a21f17c
              3f91b3afe1f9968211303f5d1ab2e9299e710d4a
              665ac842f263242d31bd586d18658014dfd7b215
              6f48acc73e1b4e483683ca7b5642085f2c17da4d
              26dd74f01b267c89814bca548286c476bfca7405
              5dfafb13bfd6a2bb52a3938be7fbaade1c3baa55
              e96e00aed1eba517e02a34fae6231bc7bb32a9cf
              1d662490df3153fdac5ed3638f1d022b88283225
              1d970d29256b8e937f5f6492fffe9b163cb023d5
            )

    Github.any_instance.expects(:revisions).returns(shas)
    Github.any_instance.expects(:commit_count).returns(22)
    @project.snapshots!

    assert_equal 10,          @project.snapshots.size
    assert_equal array,       @project.snapshots
    assert_equal array.first, @project.head_revision
  end

  test "source" do
    assert_equal "GitHub", @project.source.class.name
  end

  test "save" do
    @project.expects(:analyze).returns(true)

    assert_equal 0, Project.all.count
    @project.save

    assert_equal 1, Project.all.count
  end

  test "all" do
    @project.save
    assert_equal 1, Project.all.count
  end

  test "create" do
    Project.any_instance.expects(:async_save).returns(true)
    project = Project.create('github.com/holman/hopper')
  end

  test "find" do
    @project.save
    assert_equal @project.url, Project.find(@project.id).url
  end
end