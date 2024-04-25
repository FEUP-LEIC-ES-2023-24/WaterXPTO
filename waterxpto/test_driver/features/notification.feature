Feature: Notifications

  Scenario: User can enable notifications
    Given the user has disabled notifications
    When the user enables notifications
    Then the user should be able to receive notifications

  Scenario: User can disable notifications
    Given the user has enabled notifications
    When the user disables notifications
    Then the user should not be able to receive notifications

  Scenario: App requests permission to send notifications for the first time
    Given the user opens the app for the first time
    When the app requests permission to send notifications
    And the user accepts the request
    Then the user should be able to receive notifications

  Scenario: App requests permission to send notifications for the first time
    Given the user opens the app for the first time
    When the app requests permission to send notifications
    And the user denies the request
    Then the user should not be able to receive notifications

  Scenario: User clicks on a notification
    Given the user receives a notification
    When the user clicks on the notification
    Then the app should open the main screen