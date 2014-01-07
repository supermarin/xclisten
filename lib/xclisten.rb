require 'xclisten/version'
require 'xclisten/shell_task'
require 'listen'

class XCListen

  attr_reader :device
  attr_reader :scheme
  attr_reader :sdk
  attr_reader :workspace

  def initialize(opts = {})
    @scheme = opts[:scheme] || project_name
    @sdk = opts[:sdk] || 'iphonesimulator'
    @workspace = opts[:workspace] || workspace_path
    @device = IOS_DEVICES[opts[:device]] || IOS_DEVICES['iphone5s']
  end

  IOS_DEVICES = {
    'iphone5s' => 'iPhone Retina (4-inch 64-bit)',
    'iphone5' => 'iPhone Retina (4-inch)',
    'iphone4' => 'iPhone Retina (3.5-inch)',
    'ipad2' => 'iPad',
    'ipad4' => 'iPad Retina',
    'ipad_air' => 'iPad Retina (64-bit)'
  }

  def workspace_path
    @workspace_path ||= Dir.glob("**/*.xcworkspace").sort_by(&:length).first
  end

  def project_name
    @project_name ||= File.basename(workspace_path, ".*") if workspace_path
  end

  def xcodebuild
    cmd = "xcodebuild -workspace #{workspace} -scheme #{scheme} -sdk #{sdk} -configuration Debug"
    cmd += " -destination 'name=#{device}'" unless @sdk == 'macosx'
    cmd
  end

  def xctest
    @@xctest ||= `#{xcodebuild} -find-executable xctest`.strip
  end

  def install_pods
    Dir.chdir(File.dirname(workspace)) do
      system 'pod install'
      puts 'Giving Xcode some time to index...'
      sleep 10
    end
  end

  def configure_environment
    task = `#{xcodebuild} -showBuildSettings test`
    task.each_line do |line|
      if line =~ /^\s(.*)=(.*)/
        variable, value = line.split('=')
        ENV[variable.strip] = value.strip
      end
    end
    ENV['DYLD_FRAMEWORK_PATH'] = ENV['BUILT_PRODUCTS_DIR']
    ENV['DYLD_LIBRARY_PATH']   = ENV['BUILT_PRODUCTS_DIR']
  end

  def run_xctest(test_class, test_method)
    configure_environment
    ShellTask.run("#{xcodebuild} | xcpretty -c")
    bundle_path = "#{ENV['BUILT_PRODUCTS_DIR']}/#{ENV['FULL_PRODUCT_NAME']}"
    scope = xctest_scope(test_class, test_method)
    ShellTask.run("#{xctest} #{scope} #{bundle_path}")
  end

  def xctest_scope(test_class, test_method)
    return "" unless test_class
    return "-test #{test_class}/#{test_method}" if test_method
    "-test #{test_class}"
  end

  def run_tests
    ShellTask.run("#{xcodebuild} test 2> xcodebuild_error.log | xcpretty -tc")
  end

  #TODO TEST THIS SPIKE
  def validate_run
    unless can_run?
      puts "[!] No xcworkspace found in this directory (or any child directories)"
      exit 1
    end
  end

  def can_run?
    project_name && !project_name.empty?
  end

  def listen
    validate_run
    puts "Started xclistening to #{workspace}"
    ignored = [/.git/, /.xc(odeproj|workspace|userdata|scheme|config)/, /.lock$/, /\.txt$/, /\.log$/]

    listener = Listen.to(Dir.pwd, :ignore => ignored) do |modified, added, removed|
      system 'clear'
      if modified.first =~ /Podfile$/
        install_pods
      else
        run_tests
      end
    end

    listener.start
    sleep
  end

end

