require 'spec_helper'

describe User do
  before(:each) do
    @attributes = {
      name: "Example User",
      email: "user@example.com",
      password: "foobar",
      password_confirmation: "foobar"
    }
  end

  describe "validates attributes" do
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

  describe "password validations" do
    it "requires a password" do
      user_without_password = User.new @attributes.merge(password: "", password_confirmation: "")
      user_without_password.should_not be_valid
    end

    it "requires a matching password confirmation" do
      user_with_invalid_password_confirmation = User.new @attributes.merge(password_confirmation: "invalid")
      user_with_invalid_password_confirmation.should_not be_valid
    end

    it "rejects short passwords" do
      short_password = "a" * 5
      User.new( @attributes.merge(password: short_password, password_confirmation: short_password) ).should_not be_valid
    end

    it "rejects long passwords" do
      long_password = "a" * 41
      User.new( @attributes.merge(password: long_password, password_confirmation: long_password) ).should_not be_valid
    end
  end

  describe "#authenticate" do
    before(:each) do
      @user = User.create! @attributes
    end

    it "returns nil on email/password mismatch" do
      wrong_password_user = User.authenticate @attributes[:email], "wrongpass"
    end

    it "returns nil for an email address with no user" do
      no_user = User.authenticate "bar@foo.com", @attributes[:password]
      no_user.should be_nil
    end

    it "returns the user on email/password match" do
      matching_user = User.authenticate @attributes[:email], @attributes[:password]
      matching_user.should == @user
    end
  end

  it { should respond_to(:password_confirmation) }
  it { should respond_to(:remember_token) }
  it { should respond_to(:authenticate) }

  describe "remember token" do
    before do
      @user = User.new name: 'Example User', email: 'user@example.com', password: 'foobar', password_confirmation: 'foobar'
    end

    subject { @user }

    before { @user.save }
    its(:remember_token) { should_not be_blank }
  end
end
