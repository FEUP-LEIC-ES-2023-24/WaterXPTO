Feature: Timer to register the time spent on a task

    Scenario: User starts a task
        Given the user is on the main page
        And the user clicks on the Timer button
        When the user clicks on the Start button
        Then the timer starts counting

    Scenario: User stops a task
        Given the user is on the main page
        And the user clicks on the Timer button
        And the user clicks on the Start button
        When the user clicks on the Stop button
        Then the timer stops counting

    Scenario: User pauses a task
        Given the user is on the main page
        And the user clicks on the Timer button
        And the user clicks on the Start button
        When the user clicks on the Pause button
        Then the timer pauses

    Scenario: User resumes a task
        Given the user is on the main page
        And the user clicks on the Timer button
        And the user clicks on the Start button
        And the user clicks on the Pause button
        When the user clicks on the Resume button
        Then the timer resumes counting
