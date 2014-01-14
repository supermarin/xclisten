Given(/^I am in a directory with an xcworkspace$/) do
  set_run_path('dir_with_xcworkspace')
end

Given(/^I am in a directory with a nested xcworkspace$/) do
  set_run_path('dir_with_nested_xcworkspace')
end

Given(/^I am in a directory with multiple xcworkspaces$/) do
  set_run_path('dir_with_multiple_xcworkspaces')
end

Given(/^I am in a directory without an xcworkspace$/) do
  set_run_path('dir_without_xcworkspace')
end

When(/^I run xclisten with flags "(.*?)"$/) do |flags|
  run_xclisten(flags)
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