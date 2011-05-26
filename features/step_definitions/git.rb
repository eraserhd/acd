
Then /^I should have a clone of "([^"]*)" in "([^"]*)"$/ do |source_repo, target_repo|
  abort "#{target_repo} is not a clone of #{source_repo}" unless @scenario.is_clone?(source_repo, target_repo)
end

Then /^I should have "([^"]*)" registered as a submodule$/ do |target_repo|
  abort "'#{target_repo}' is not registered as a submodule" unless @scenario.submodule?(target_repo)
end

Then /^I should not have uncommitted changes for "([^"]*)"$/ do |path|
  abort "'#{path}' has uncommitted changes" if @scenario.has_uncommitted_changes?(path)
end

Then /^I should not have uncommitted changes$/ do
  abort "has uncommitted changes" if @scenario.has_uncommitted_changes?
end

Then /^the last log message should contain "([^"]*)"$/ do |text|
  abort "Last log message does not contain '#{text}'" unless @scenario.last_log_message_contains?(text)
end

Then /^"([^"]*)" should exist$/ do |file|
  abort "'#{file}' does not exist" unless @scenario.file_exists?(file)
end
