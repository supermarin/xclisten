
BIN_PATH = File.expand_path('../../bin/xclisten', File.dirname(__FILE__))

def run_xclisten(flags)
  Dir.chdir(@basedir) do
    @output = %x(#{BIN_PATH} #{flags})
  end
end

def set_run_path(dirname)
  @basedir = File.expand_path("../fixtures/#{dirname}", File.dirname(__FILE__))
end

def run_output
  @output
end

def xcworkspace_path
  if workspace_setting = run_output.each_line.to_a.detect {|l| l.start_with? "Workspace: "}
    workspace_setting.gsub("Workspace: ", "")
  else
    ""
  end
end

Before do
  @basedir = Dir.pwd
end