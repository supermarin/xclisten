class XCListen

  class ShellTask

    def self.run(args)
      puts args + "\n\n"
      fork { exec args }
    end

  end

end

