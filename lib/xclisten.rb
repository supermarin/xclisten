require 'xclisten/version'
require 'xclisten/shell_task'
require 'listen'

class XCListen

  attr_reader :device
  attr_reader :scheme
  attr_reader :sdk
  attr_reader :workspace

  def initialize(opts = {})
    @device = IOS_DEVICES[opts[:device]] || IOS_DEVICES['iphone5s']
    @scheme = opts[:scheme] || project_name
    @sdk = opts[:sdk] || 'iphonesimulator'
    @workspace = opts[:workspace] || workspace_path
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
    "xcodebuild -workspace #{workspace} -scheme #{scheme} -sdk #{sdk} -destination 'name=#{device}'"
  end

  def install_pods
    Dir.chdir(File.dirname(workspace)) do
      system 'pod install'
      puts 'Giving Xcode some time to index...'
      sleep 10
    end
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

