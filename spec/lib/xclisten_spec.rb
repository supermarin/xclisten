require 'xclisten'

class XCListen

  describe XCListen do

    class ShellTask
      def run(args)
        @command = args
      end
    end

    before(:each) do
      Dir.stub(:glob).and_return(['SampleProject.xcworkspace'])
    end

    context "Defaults" do

      before(:each) do
        @xclisten = XCListen.new
      end

      it "runs runs tests on iPhone 5s by default" do
        @xclisten.device.should == 'iPhone Retina (4-inch 64-bit)'
      end

      it "uses the project name as the default scheme" do
        @xclisten.scheme.should == 'SampleProject'
      end

      it "uses the first found workspace by default" do
        @xclisten.workspace.should == 'SampleProject.xcworkspace'
      end

      it "uses iphonesimulator sdk by default" do
        @xclisten.sdk.should == 'iphonesimulator'
      end

    end

    it "initializes with device" do
      xclisten = XCListen.new(:device => 'iphone5')
      xclisten.device.should == 'iPhone Retina (4-inch)'
    end

    it "initializes with a different workspace" do
      xclisten = XCListen.new(:workspace => 'Example/Sample.xcworkspace')
      xclisten.workspace.should == 'Example/Sample.xcworkspace'
    end

    it "initializes with a different scheme" do
      xclisten = XCListen.new(:scheme => 'AnotherScheme')
      xclisten.scheme.should == 'AnotherScheme'
    end

    it 'initializes with SDK' do
      xclisten = XCListen.new(:sdk => 'iphonesimulator')
      xclisten.sdk.should == 'iphonesimulator'
    end

    it 'uses xcodebuild with given flags' do
      xclisten = XCListen.new
      xclisten.xcodebuild.should == "xcodebuild -workspace SampleProject.xcworkspace -scheme SampleProject -sdk iphonesimulator -destination 'name=iPhone Retina (4-inch 64-bit)'"
    end
  end

end

