
Then /^I should have a clone of "([^"]*)" in "([^"]*)"$/ do |source_repo, target_repo|
  abort "#{target_repo} is not a clone of #{source_repo}" unless @scenario.is_clone?(source_repo, target_repo)
end

Then /^I should have "([^"]*)" registered as a submodule$/ do |target_repo|
  abort "'#{target_repo}' is not registered as a submodule" unless @scenario.submodule?(target_repo)
end

Then /^I should not have uncommitted changes for "([^"]*)"$/ do |path|
  pending
end

Then /^the last log message should contain "([^"]*)"$/ do |text|
  pending
end

