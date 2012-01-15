require 'spec_helper'

describe User do
  describe "validates attributes" do
    before(:each) do
      @attributes = { name: "Example User", email: "user@example.com" }
    end
  
    it "creates a new user instance given valid attributes" do
      User.create!(@attributes)
    end
  
    it "requires a name" do
      no_name_user = User.new(@attributes.merge(name: ""))
      no_name_user.should_not be_valid
    end
  
    it "requires an email address" do
      no_email_user = User.new(@attributes.merge(email: ""))
      no_email_user.should_not be_valid
    end
  
    it "rejects names that are too long" do
      long_name = "a" * 51
      long_name_user = User.new @attributes.merge(name: long_name)
      long_name_user.should_not be_valid
    end
  
    it "accepts valid email addresses" do
      addresses = %w[user@foo.com THE_USER@foo.bar.org first.last@foo.jp]
      addresses.each do |address|
        valid_email_address = User.new @attributes.merge(email: address)
        valid_email_address.should be_valid
      end
    end

    it "rejects invalid email addresses" do
      addresses = %w[user@foo,com user_at_foo.org example.user@foo.]
      addresses.each do |address|
        invalid_email_address = User.new @attributes.merge(email: address)
        invalid_email_address.should_not be_valid
      end
    end
  
    it "rejects duplicate email addresses" do
      User.create! @attributes
      user_with_duplicate_email = User.new @attributes
      user_with_duplicate_email.should_not be_valid
    end
  
    it "rejects duplicate email addresses identical up to case" do
      upcased_email = @attributes[:email].upcase
      User.create! @attributes.merge(email: upcased_email)
      user_with_duplicate_email = User.new @attributes
      user_with_duplicate_email.should_not be_valid
    end
  end
end