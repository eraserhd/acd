
Then /^I should have a target named "([^"]*)"$/ do |target|
  xcode_targets.should include(target)
end

Then /^the "([^"]*)" target should build$/ do |target|
  build_xcode_target(target).should be_true
end

