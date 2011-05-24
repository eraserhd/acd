Feature: Importing third party repositories
  As an app developer,
  in order use third party code in an easy and standard way,
  I'd like to be able to tell acd to import a third party repository as a submodule.

  Scenario: Basic acd import
    Given "$ROOT/foo" is a third party repo
    When I run "acd import $ROOT/foo"
    Then I should have a clone of "$ROOT/foo" in "submodules/foo"
    And I should have "submodules/foo" registered as a submodule
    And I should not have uncommitted changes for ".gitmodules"
    And I should not have uncommitted changes for "submodules/foo"
    And the last log message should contain "Import foo"

  Scenario: Import using a remedy file
    Given "$ROOT/foo" is a third party repo
    And acd has a remedy "foo" with repository: "$ROOT/foo"
    When I run "acd import foo"
    Then I should have a clone of "$ROOT/foo" in "submodules/foo"
    And I should have "submodules/foo" registered as a submodule
    And I should not have uncommitted changes for ".gitmodules"
    And I should not have uncommitted changes for "submodules/foo"
    And the last log message should contain "Import foo"

  @wip
  Scenario: Import using a remedy file, but override the repository
    Given "$ROOT/foo" is a third party repo
    And acd has a remedy "foo" with repository: "$ROOT/bar"
    When I run "acd import foo --from $ROOT/foo"
    Then I should have a clone of "$ROOT/foo" in "submodules/foo"
    And I should have "submodules/foo" registered as a submodule
    And I should not have uncommitted changes for ".gitmodules"
    And I should not have uncommitted changes for "submodules/foo"
    And the last log message should contain "Import foo"
