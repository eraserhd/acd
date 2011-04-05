
Before do
  @scenario = Scenario.new
end

After do
  if @scenario
    @scenario.cleanup
    @scenario = nil
  end
end

Given /^I am in the sample project$/ do
  @scenario.make_sample_project
end

Given /^"([^"]*)" is a third party repo$/ do |path|
  @scenario.make_third_party_repo(path)
end

