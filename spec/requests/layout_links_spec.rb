require 'spec_helper'

describe "LayoutLinks" do
  it "should have a Home page at '/'" do
    visit root_path
    page.should have_selector('title', text: 'Home')
  end

  it "should have a Contact page at '/contact'" do
    visit contact_path
    page.should have_selector('title', text: 'Contact')
  end

  it "should have a About page at '/about'" do
    visit about_path
    page.should have_selector('title', text: 'About')
  end

  it "should have a Help page at '/help'" do
    visit help_path
    page.should have_selector('title', text: 'Help')
  end
end
