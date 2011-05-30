
Before do
  boot_cage
end

Given /^"([^"]*)" is a third party repo$/ do |path|
  make_third_party_repo path
end

Given /^acd has a remedy "([^"]*)"$/ do |remedy_name|
  make_remedy remedy_name
end

Given /^the remedy has ([^"]*): "([^"]*)"$/ do |name, value|
  set_remedy_property name, value
end

Given /^the remedy wants an Xcode project file$/ do
  remedy_wants_xcode
end

