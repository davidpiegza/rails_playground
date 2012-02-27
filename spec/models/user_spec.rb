require 'spec_helper'

describe User do
  let(:user) { FactoryGirl.create(:user) }
  before do
    @attributes = {
      name: "Example User",
      email: "user@example.com",
      password: "foobar",
      password_confirmation: "foobar"
    }
  end

  subject { user }

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
  it { should respond_to(:microposts) }
  it { should respond_to(:feed) }
  it { should respond_to(:relationships) }
  it { should respond_to(:reverse_relationships) }
  it { should respond_to(:followed_users) }
  it { should respond_to(:followers) }
  it { should respond_to(:following?) }
  it { should respond_to(:follow!) }
  it { should respond_to(:admin) }

  it { should be_valid }
  it { should_not be_admin }

  describe "remember token" do
    before do
      @user = User.new name: 'Example User', email: 'user@example.com', password: 'foobar', password_confirmation: 'foobar'
    end

    subject { @user }

    before { @user.save }
    its(:remember_token) { should_not be_blank }
  end

  describe "with admin attribute set to true" do
    before { user.toggle!(:admin) }
    it { should be_admin }
  end

  describe "micropost associations" do
    before { user.save }
    let!(:older_micropost) do
      FactoryGirl.create :micropost, user: user, created_at: 1.day.ago
    end
    let!(:newer_micropost) do
      FactoryGirl.create :micropost, user: user, created_at: 1.hour.ago
    end

    it "should have the right microposts in the right order" do
      user.microposts.should == [newer_micropost, older_micropost]
    end

    it "should destroy associated microposts" do
      microposts = user.microposts
      user.destroy
      microposts.each do |micropost|
        Micropost.find_by_id(micropost.id).should be_nil
      end
    end

    describe "status" do
      let(:unfollowed_post) do
        FactoryGirl.create(:micropost, user: FactoryGirl.create(:user))
      end
      let(:followed_user) { FactoryGirl.create(:user) }

      before do
        user.follow!(followed_user)
        3.times { followed_user.microposts.create!(content: "Lorem ipsum") }
      end

      its(:feed) { should include(newer_micropost) }
      its(:feed) { should include(older_micropost) }
      its(:feed) { should_not include(unfollowed_post) }
      its(:feed) do
        followed_user.microposts.each do |micropost|
          should include(micropost)
        end
      end
    end
  end

  describe "following" do
    let(:other_user) { FactoryGirl.create(:user) }
    before do
      user.save
      user.follow!(other_user)
    end

    it { should be_following(other_user) }
    its(:followed_users) { should include(other_user) }

    describe "followed user" do
      subject { other_user }
      its(:followers) { should include(user) }
    end

    describe "and unfollowing" do
      before { user.unfollow!(other_user) }

      it { should_not be_following(other_user) }
      its(:followed_users) { should_not include(other_user) }
    end
  end
end
