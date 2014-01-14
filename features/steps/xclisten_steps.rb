Given(/^I am in a directory with an xcworkspace$/) do
  @basedir = File.expand_path('../fixtures/dir_with_xcworkspace', File.dirname(__FILE__))
end

Given(/^I am in a directory with a nested xcworkspace$/) do
  @basedir = File.expand_path('../fixtures/dir_with_nested_xcworkspace', File.dirname(__FILE__))
end

Given(/^I am in a directory with multiple xcworkspaces$/) do
  @basedir = File.expand_path('../fixtures/dir_with_multiple_xcworkspaces', File.dirname(__FILE__))
end

Given(/^I am in a directory without an xcworkspace$/) do
  @basedir = File.expand_path('../fixtures/dir_without_xcworkspace', File.dirname(__FILE__))
end

When(/^I run xclisten with flags "(.*?)"$/) do |flags|
  run_xclisten(flags, @basedir || Dir.pwd)
end

Then(/^xclisten should be listening to the xcworkspace in the current directory$/) do
  xcworkspace_path.should =~ /Sample.xcworkspace$/
end

Then(/^xclisten should be listening to the xcworkspace nested in the current directory$/) do
  xcworkspace_path.should =~ /NestedSample.xcworkspace$/
end

Then(/^xclisten should be listening to the first xcworkspace listed alphabetically$/) do
  xcworkspace_path.should =~ /A.xcworkspace$/
end

Then(/^I should get an error message about no xcworkspace being found$/) do
  run_output.should =~ /^\[!\] No xcworkspace found in this directory/
end