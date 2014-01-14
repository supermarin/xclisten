Feature: Checking if a directory has a xcworkspace

    Scenario: There is an xcworkspace in the current directory
        Given I am in a directory with an xcworkspace
        When I run xclisten with flags ""
        Then xclisten should be listening to the xcworkspace in the current directory

    Scenario: There is an xcworkspace in a nested directory
        Given I am in a directory with a nested xcworkspace
        When I run xclisten with flags ""
        Then xclisten should be listening to the xcworkspace nested in the current directory

    Scenario: There are multiple xcworkspaces nested in the current directory
        Given I am in a directory with multiple xcworkspaces
        When I run xclisten with flags ""
        Then xclisten should be listening to the first xcworkspace listed alphabetically

    Scenario: There are no xcworkspaces in the current directory
        Given I am in a directory without an xcworkspace
        When I run xclisten with flags ""
        Then I should get an error message about no xcworkspace being found