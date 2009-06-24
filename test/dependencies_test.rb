require "rubygems"
require "ruby-debug"

gem "contest"
gem "override"

require "contest"
require "override"

require "pp"
require "stringio"
require "fileutils"

class DependenciesTest < Test::Unit::TestCase
  include Override

  def do_require
    load File.join(File.dirname(__FILE__), "..", "lib", "dependencies.rb")
  end

  def with_dependencies(deps)
    File.open("dependencies", "w") do |f|
      f.write(deps)
    end

    yield
  ensure
    FileUtils.rm("dependencies")
  end

  setup do
    @load_path = $LOAD_PATH.dup
  end

  test "loads dependencies from ./vendor" do
    with_dependencies "bar" do
      do_require

      assert_equal File.expand_path("vendor/bar/lib"), $:[1]
    end
  end

  test "add ./lib to the load path" do
    with_dependencies "" do
      do_require

      assert_equal File.expand_path("lib"), $:.first
    end
  end

  test "alert about missing dependencies" do
    with_dependencies "foo 1.0" do
      err = capture_stderr do
        do_require
      end

      assert err.include?("Missing dependencies:\n\n  foo 1.0")
    end
  end

  test "load environment-specific dependencies" do
    begin
      ENV["RACK_ENV"] = "integration"

      with_dependencies "bar\nbarz 2.0 (test)\nbaz 1.0 (integration)" do
        do_require

        assert $:.include?(File.expand_path("vendor/bar/lib"))
        assert $:.include?(File.expand_path("vendor/baz-1.0/lib"))
        assert !$:.include?(File.expand_path("vendor/barz-2.0/lib"))
      end

    ensure
      ENV.delete "RACK_ENV"
    end
  end

  teardown do
    $LOAD_PATH.replace(@load_path)
  end

protected

  def capture_stderr
    begin
      err, $stderr = $stderr, StringIO.new
      yield
    ensure
      $stderr, err = err, $stderr
    end
    err.string
  end
end
