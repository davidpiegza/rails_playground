Feature: Get content pages

In order to get information about this web app
As a visitor
I want to be able to access the content pages

Scenario Outline: Visitor requests a content page
  When I visit the content page <page>
  Then I should see a title <title>

Scenarios:
  | page      | title     |
  | "home"    | "Home"    |
  | "contact" | "Contact" |
  | "about"   | "About"   |
