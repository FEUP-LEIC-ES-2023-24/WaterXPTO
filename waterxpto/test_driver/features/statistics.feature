Feature: Statistics

    Scenario: User opens the statistics page
        Given the user is in the main page
        When the user clicks on the statistics button
        Then the user should be redirected to the statistics page

    Scenario: User opens monthly statistics
        Given the user is in the statistics page
        When the user clicks on the month statistics button
        Then the user should be redirected to the monthly statistics page

    Scenario: User opens yearly statistics
        Given the user is in the statistics page
        When the user clicks on the year statistics button
        Then the user should be redirected to the yearly statistics page