When /^I visit the content page "([^"]*)"$/ do |page|
  visit("#{page}")
end

Then /^I should see a title "([^"]*)"$/ do |title|
  within('head title') { page.should have_content(title) }
end
