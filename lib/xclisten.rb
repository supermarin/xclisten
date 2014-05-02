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
    cmd += " -arch #{@arch} #{valid_archs}" if @arch
    cmd
  end

  def xctest
    @@xctest ||= begin
      cmd = `#{xcodebuild} -find-executable xctest`.strip
      arch_cmd = native_arch ? "arch -arch #{native_arch}" : ''
      "#{arch_cmd} -e DYLD_ROOT_PATH='#{@env['SDK_DIR']}' #{cmd}"
    end
  end

  def install_pods
    Dir.chdir(File.dirname(workspace)) do
      system 'pod install'
      puts 'Giving Xcode some time to index...'
      sleep 10
    end
  end

  def configure_environment
    @env = {}
    @env_text = ""
    task = `#{xcodebuild} -showBuildSettings test`
    task.each_line do |line|
      if line =~ /^\s(.*)=(.*)/
        variable, value = line.split('=').map {|v| v.strip }
        @env[variable] = value
        @env_text += "#{variable}=#{value} "
      end
    end
    @env['DYLD_FRAMEWORK_PATH'] = @env['BUILT_PRODUCTS_DIR']
    @env['DYLD_LIBRARY_PATH']   = @env['BUILT_PRODUCTS_DIR']
    @bundle_path = "#{@env['BUILT_PRODUCTS_DIR']}/#{@env['FULL_PRODUCT_NAME']}"
  end

  def run_xctest(test_classes)
    configure_environment
    ShellTask.run("#{xcodebuild} 1> /dev/null")
    test_classes.each do |test_class|
      ShellTask.run("#{@env_text} #{xctest} -XCTest #{test_class} #{@bundle_path}")
    end
  end

  def is_valid_arch?(arch)
    ['i386', 'x86_64'].include?(arch)
  end

  def native_arch
    @native_arch ||= begin
      arch = `file #{@bundle_path}`.split(' ').last
      native_arch = is_valid_arch?(arch) ? arch : @env['CURRENT_ARCH']
      is_valid_arch?(native_arch) ? native_arch : 'i386'
    end
  end

  def valid_archs
    return unless @env && @env['VALID_ARCHS'] && @env['CURRENT_ARCH']

    @env['VALID_ARCHS'].include?(@env['CURRENT_ARCH']) ? '' : "VALID_ARCHS=#{@arch}"
  end

  def run_tests(test_classes)
    puts "test classes: #{test_classes}"
    if test_classes and test_classes.size > 0
      run_xctest(test_classes)
    else
      ShellTask.run("#{xcodebuild} test 2> xcodebuild_error.log | xcpretty -tc")
    end
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
        run_tests(find_test_classes(modified))
      end
    end

    listener.start
    sleep
  end

  def find_test_classes(files)
    files.map do |path|
      if path =~ %r{/(\w+(Tests|Spec))\.(h|m)$}
        path
      elsif path =~ %r{/(\w+)\.(h|m)$}
        Dir.glob("**/#{$1}{Tests,Spec}.m")
      end
    end.flatten.compact.map {|path| File.basename(path, ".*") }
  end

end

