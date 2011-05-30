Feature: Xcode Support
  As a developer,
  In order to save lots of time,
  I want acd to manipulate my Xcode project file.

  Scenario: Initializes an xcodeproj if requested
    Given "$ROOT/foo" is a third party repo
    And acd has a remedy "foo" with:
       """
       ACD::Remedy.new do |r|
         r.repository = '$ROOT/foo'
         r.xcode_project do |p|
         end
       end
       """
    When I run `acd import foo`
    Then a file named "project.xcodeproj/project.pbxproj" should exist
    And I should not have uncommitted changes
