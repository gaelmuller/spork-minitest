class Spork::TestFramework::MiniTest < Spork::TestFramework
  DEFAULT_PORT = 8988
  DEFAULT_HELPER_FILES = %w[test/minitest_helper.rb test/test_helper.rb spec/spec_helper.rb]

  def self.helper_file
    ENV['HELPER_FILE'] || DEFAULT_HELPER_FILES.find{ |f| File.exist?(f) }
  end

  def run_tests(argv, stderr, stdout)
    require "minitest/unit"
    ::MiniTest::Unit.output = stdout

    paths, opts = parse_options(argv)

    paths.each do |path|
      load path
    end

    ::MiniTest::Unit.new.run(opts)
  end

  def parse_options(argv)
    paths, opts = argv.slice_before("--").to_a
    paths ||= []
    opts ||= []
    opts.shift

    paths.each_with_index do |path, idx|
      if path =~ /-I(.*)/
        if $1 == ''
          include_path = paths[idx + 1]
          paths[idx + 1] = nil
        else
          include_path = $1
        end
        $LOAD_PATH << include_path
        paths[idx] = nil
      end
    end

    [paths.compact!, opts]
  end
end
