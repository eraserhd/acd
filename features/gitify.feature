Feature: Initializing a project
  As an app developer,
  in order to save time with rote steps,
  I'd like to be able to tell acd to gititfy this project.

  Scenario: Running gitify
    Given I am not in a git repo
    And a file named "README" with:
    	"""
	This is a test file.
	"""
    When I successfully run `acd gitify`
    Then I should not have uncommitted changes
    And the file ".gitignore" should contain "build"
    And the file ".gitignore" should contain "xcuserdata"
    And the file ".gitignore" should contain "*.xcworkspace"
