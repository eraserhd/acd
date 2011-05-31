Feature: Xcode Support
  As a developer,
  In order to save lots of time,
  I want acd to manipulate my Xcode project file.

  Scenario: Initializes an xcodeproj when the remedy requests
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

  @wip
  Scenario: Copies Xcode targets when the remedy requests
    Given "$ROOT/foo" is a third party repo
    And the repo "$ROOT/foo" has a file "template.pbxproj" with the contents of "spec/fixtures/template.pbxproj"
    And acd has a remedy "foo" with:
       """
       ACD::Remedy.new do |r|
         r.repository = '$ROOT/foo'
         r.xcode_project do |p|
           p.import_target 'Foo', :from => 'template.pbxproj'
         end
       end
       """
    When I run `acd import foo`
    Then I should have a target named "Foo"
    And the "Foo" target should build
