module XCListen

  class ShellTask

    def self.run(args)
      puts args + "\n\n"
      `#{args}`
    end

  end

end

