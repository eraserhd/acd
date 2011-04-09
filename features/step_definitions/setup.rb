
Before do
  @scenario = Scenario.new
end

After do
  if @scenario
    @scenario.cleanup
    @scenario = nil
  end
end

Given /^"([^"]*)" is a third party repo$/ do |path|
  @scenario.make_third_party_repo(path)
end

