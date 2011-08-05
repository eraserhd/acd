
Then /^I should have a clone of "([^"]*)" in "([^"]*)"$/ do |source_repo, target_repo|
  abort "#{target_repo} is not a clone of #{source_repo}" unless is_clone?(source_repo, target_repo)
end

Then /^I should have "([^"]*)" registered as a submodule$/ do |target_repo|
  abort "'#{target_repo}' is not registered as a submodule" unless submodule?(target_repo)
end

Then /^I should not have uncommitted changes for "([^"]*)"$/ do |path|
  abort "'#{path}' has uncommitted changes" if has_uncommitted_changes?(path)
end

Then /^I should not have uncommitted changes$/ do
  abort "has uncommitted changes" if has_uncommitted_changes?
end

Then /^the last log message should contain "([^"]*)"$/ do |text|
  abort "Last log message does not contain '#{text}'" unless last_log_message_contains?(text)
end

Given /^the repo "([^"]*)" has a file "([^"]*)" with the contents of "([^"]*)"$/ do |repo, file, other_file|
  commit_file_to_repo(repo, file, File.read(other_file))
end

Given /^I am not in a git repo$/ do
  unmake_git_repo
end

Then /^the following should be ignored by git:$/ do |table|
  # table is a Cucumber::Ast::Table
  pending # express the regexp above with the code you wish you had
end

