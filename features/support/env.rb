
BIN_PATH = File.expand_path('../../bin/xclisten', File.dirname(__FILE__))

def run_xclisten(flags, basedir=Dir.pwd)
  Dir.chdir(basedir) do
    @output = %x(#{BIN_PATH} #{flags} --print-settings)
  end
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