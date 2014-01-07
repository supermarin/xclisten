require 'xclisten/version'
require 'xclisten/shell_task'
require 'listen'

class XCListen

  attr_reader :device, :scheme, :sdk

  def initialize(opts = {})
    @device = IOS_DEVICES[opts[:device]] || IOS_DEVICES['iphone5s']
    @scheme = opts[:scheme] || project_name
    @sdk = opts[:sdk] || 'iphonesimulator'
  end

  IOS_DEVICES = {
    'iphone5s' => 'iPhone Retina (4-inch 64-bit)',
    'iphone5' => 'iPhone Retina (4-inch)',
    'iphone4' => 'iPhone Retina (3.5-inch)'
  }

  def self.can_run?
    if Dir.entries(Dir.pwd).detect { |f| f =~ /.xcworkspace/ }.nil?
      puts "Please run xclisten from a directory with an xcworkspace."
      return false;
    end
    
    true
  end

  def has_workspaces?
    workspace_name.nil?
  end

  #TODO: make this recursive
  def workspace_name
    Dir.entries(Dir.pwd).detect { |f| f =~ /.xcworkspace/ }
  end

  #TODO: when workspace_name gets recursive, use `basename`
  def project_name
    workspace_name.split('.').first
  end

  def xcodebuild
    "xcodebuild -workspace #{workspace_name} -scheme #{@scheme} -sdk #{@sdk} -destination 'name=#{@device}'"
  end

  def install_pods
    system 'pod install'
    puts 'Giving Xcode some time to index...'
    sleep 10
  end

  def run_tests
    ShellTask.run("#{xcodebuild} test 2> xcodebuild_error.log | xcpretty -tc")
  end

  def listen    
    puts "Started xclistening to #{workspace_name}"
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

