Feature: Xcode Support
  As a developer,
  In order to save lots of time,
  I want acd to manipulate my Xcode project file.

  Scenario: Initializes an xcodeproj if necessary
    Given "$ROOT/foo" is a third party repo
    And acd has a remedy "foo"
    And the remedy has repository: "$ROOT/foo"
    And the remedy wants an Xcode project file
    When I run "acd import foo"
    Then "project.xcodeproj/project.pbxproj" should exist
    And I should not have uncommitted changes
