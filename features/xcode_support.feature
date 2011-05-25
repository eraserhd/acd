Feature: Xcode Support
  As a developer,
  In order to save lots of time,
  I want acd to manipulate my Xcode project file.

  @wip
  Scenario: Initializes an xcodeproj if necessary
    Given "$ROOT/foo" is a third party repo
    And acd has a remedy "foo" with repository: "$ROOT/foo"
    And the remedy wants an Xcode project file
    When I run "acd import $ROOT/foo"
    Then I should have a file "project.xcodeproj/project.pbxproj"
    And I should not have uncommitted changes for "project.xcodeproj/project.pbxproj"
    And I should be able to build the project
