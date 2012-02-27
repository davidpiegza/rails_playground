class User < ActiveRecord::Base
  attr_accessible :name, :email, :password, :password_confirmation
  has_secure_password
  
  has_many :microposts, dependent: :destroy
  has_many :relationships, foreign_key: 'follower_id', dependent: :destroy

  before_save :create_remember_token

  email_regex = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i

  validates :name, presence: true,
                   length: { maximum: 50 }
  validates :email, presence: true,
                    format: { with: email_regex },
                    uniqueness: { case_sensitive: false }

  validates :password, presence: true,
                       length: { within: 6..40 }

  def self.authenticate(email, submitted_password)
    find_by_email(email).try(:authenticate, submitted_password)
  end

  def feed
    # This is preliminary. See "Following users" for the full implementation.
    Micropost.where("user_id = ?", id)
  end

  private

  def create_remember_token
    self.remember_token = SecureRandom.urlsafe_base64
  end

end
