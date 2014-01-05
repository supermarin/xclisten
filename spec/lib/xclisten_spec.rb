require 'xclisten'

module XCListen

  def sleep; end

  describe XCListen do

    before(:each) do
      ShellTask.stub(:run)
    end

    it "uses xcodebuild" do
      ShellTask.should_receive(:run).with('xcodebuild')
      XCListen.listen
    end

  end

end

