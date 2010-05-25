# == Schema Information
# Schema version: 20100523162612
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

  # ATTRIBUTES ======================================================
  attr_accessor :password # <- creates a virtual attribute 
  attr_accessible :name, :email, :password, :password_confirmation

  ## Listing 11.7
  has_many :microposts

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
