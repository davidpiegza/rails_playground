require 'spec_helper'

describe "LayoutLinks" do
  it "should have a Home page at '/'" do
    visit root_path
    page.should have_selector('title', text: 'Home')

    describe "for signed-in users" do
      let(:user) { FactoryGirl.create(:user) }
      before do
        FactoryGirl.create(:micropost, user: user, content: 'Lorem ipsum')
        FactoryGirl.create(:micropost, user: user, content: 'Dolor sit amet')
        sign_in user
        visit root_path
      end

      it "should render the user's feed" do
        user.feed.each do |item|
          page.should have_selector("tr##{item.id}", text: item.content)
        end
      end
    end
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
