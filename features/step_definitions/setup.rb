
Before do
  @scenario = Scenario.new
end

After do
  if @scenario
    @scenario.dispose
    @scenario = nil
  end
end

Given /^"([^"]*)" is a third party repo$/ do |path|
  @scenario.make_third_party_repo(path)
end

Given /^acd has a remedy "([^"]*)"$/ do |remedy_name|
  @scenario.make_remedy(remedy_name)
end

Given /^the remedy has ([^"]*): "([^"]*)"$/ do |name, value|
  @scenario.set_remedy_property(name, value)
end

Given /^the remedy wants an Xcode project file$/ do
  @scenario.remedy_wants_xcode
end

