require "xclisten/version"
require 'listen'

module XCListen

  module_function

  SDK = '-sdk iphonesimulator'

  def workspace_name
    Dir.entries(Dir.pwd).detect { |f| f =~ /.xcworkspace/ }
  end

  def project_name
    workspace_name.split('.').first
  end

  def xcodebuild
    "xcodebuild -workspace #{workspace_name} -scheme #{project_name} #{SDK}"
  end

  def install_pods
    system 'pod install'
    puts 'Giving Xcode some time to index...'
    sleep 10
  end

  def run_tests
    task = "#{xcodebuild} test 2> xcodebuild_error.log | xcpretty -tc"
    puts task + "\n\n"
    system(task)
  end

  def listen
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

