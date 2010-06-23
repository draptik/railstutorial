# == Schema Information
# Schema version: 20100618213205
#
# Table name: users
#
#  id                 :integer         not null, primary key
#  name               :string(255)
#  email              :string(255)
#  created_at         :datetime
#  updated_at         :datetime
#  encrypted_password :string(255)
#  salt               :string(255)
#  remember_token     :string(255)
#  admin              :boolean
#

require'digest'
class User < ActiveRecord::Base

  # ASSOCIATIONS ====================================================

  ## Listing 11.7, 11.12
  has_many :microposts, :dependent => :destroy

  ## Listing 12.5 Implementing the user/relationships has_many
  ## association.
  ##
  ## This is the short form of adding "belongs_to :user" to micropost
  ## model and adding "belongs_to :has_many :microposts" to user
  ## model.
  ##
  ## An id used in this manner to connect two database tables is known
  ## as a foreign key, and when the foreign key for a User model
  ## object is user_id, Rails can infer the association automatically:
  ## by default, Rails expects a foreign key of the form <class>_id,
  ## where <class> is the lower-case version of the class name.
  has_many :relationships, :foreign_key => "follower_id",
                           :dependent => :destroy

  ## Listing 12.11 Adding the User model following association with
  ## has_many :through.
  has_many :following, :through => :relationships, :source => :followed

  ## Listing 12.17 Implementing user.followers using reverse
  ## relationships.
  has_many :reverse_relationships, :foreign_key => "followed_id",
                                   :class_name => "Relationship",
                                   :dependent => :destroy
  has_many :followers, :through => :reverse_relationships, :source => :follower


  # ATTRIBUTES ======================================================
  attr_accessor :password # <- creates a virtual attribute 
  attr_accessible :name, :email, :password, :password_confirmation


  # CONSTANTS =======================================================
  EmailRegex = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i


  # VALIDATION ======================================================
  validates_presence_of :name, :email
  validates_length_of :name, :maximum => 50
  validates_format_of :email, :with => EmailRegex
  validates_uniqueness_of :email, :case_sensitive => false

  ## Automatically create the virtual attribute 'password confirmation'
  validates_confirmation_of :password

  ## Password validations
  validates_presence_of :password
  validates_length_of :password, :within => 6..40


  # CALLBACKS =======================================================
  before_save :encrypt_password # <- this is a callback (Aspect in Java)


  # METHODS =========================================================
  # Return true if the user's password matches the submitted password.
  def has_password?(submitted_password)
    # Compare encrypted_password with the encrypted version of
    # submitted_password.
    encrypted_password == encrypt(submitted_password)
  end

  def remember_me!
    self.remember_token = encrypt("#{salt}--#{id}")
    save_without_validation
  end

  def self.authenticate(email, submitted_password)
    user = find_by_email(email)
    return nil if user.nil?
    return user if user.has_password?(submitted_password)
  end

  def feed
    ## Listing 11.32 A preliminary implementation for the micropost
    ## status feed
    #
    # This is preliminary. See Chapter 12 for the full implementation.
    #
    # The question mark ensures that id is properly escaped before
    # being included in the underlying SQL query, thereby avoiding a
    # serious security breach called SQL injection. (The id attribute
    # here is just an integer, so there is no danger in this case, but
    # always escaping variables injected into SQL statements is a good
    # habit to cultivate.)
    # Micropost.all(:conditions => ["user_id = ?", id])

    ## Listing 12.42. Adding the completed feed to the User model. 
    Micropost.from_users_followed_by(self)
  end

  ## Listing 12.13 The following? and follow! utility methods.
  def following?(followed)
    relationships.find_by_followed_id(followed)
  end

  def follow!(followed)
    relationships.create!(:followed_id => followed.id)
  end

  ## Listing 12.15 Unfollowing a user by destroying a user relationship.
  def unfollow!(followed)
    relationships.find_by_followed_id(followed).destroy
  end

  # PRIVATE =========================================================
  private

  def encrypt_password
    unless password.nil?
      self.salt = make_salt
      self.encrypted_password = encrypt(password)
    end
  end

  def encrypt(string)
    secure_hash("#{salt}#{string}")
  end

  def make_salt
    secure_hash("#{Time.now.utc}#{password}")
  end

  def secure_hash(string)
    Digest::SHA2.hexdigest(string)
  end
end
