require 'spec_helper'

describe "User pages" do
  subject { page }

  describe "signup page" do
    before { visit signup_path }

    it { should have_selector('title', text: 'Sign Up') }
    it { should have_selector('h1', text: 'Sign Up') }
  end

  describe "profile page" do
    let(:user) { FactoryGirl.create :user }
    before { visit user_path(user) }

    it { should have_selector('title', text: user.name ) }
    it { should have_selector('h1', text: user.name ) }
  end
end
