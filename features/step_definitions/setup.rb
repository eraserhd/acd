
Before do
  boot_cage
end

Given /^"([^"]*)" is a third party repo$/ do |path|
  make_third_party_repo path
end

Given /^acd has a remedy "([^"]*)" with:$/ do |name, file_content|
  write_remedy name, file_content
end

