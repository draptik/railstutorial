# == Schema Information
# Schema version: 20100618213205
#
# Table name: microposts
#
#  id         :integer         not null, primary key
#  content    :string(255)
#  user_id    :integer
#  created_at :datetime
#  updated_at :datetime
#

class Micropost < ActiveRecord::Base
  ## Listing 11.2 Making the content attribute (and only the content
  ## attribute) accessible. 
  ##
  ## Since user_id *isn't* listed as an attr_accessible parameter, it
  ## *can't* be edited through the web.
  attr_accessible :content

  ## Listing 11.6
  belongs_to :user

  ## Listing 11.10 Ordering the microposts with default_scope
  default_scope :order => 'created_at DESC'

  ## Listing 12.44. Improving from_users_followed_by. 
  # Return microposts from the users being followed by the given user.
  named_scope :from_users_followed_by, lambda { |user| followed_by(user) }

  ## Exercise 11.5.1
  MAX_CHARS = 140

  ## Listing 11.14 The Micropost model validations
  validates_presence_of :content, :user_id
  validates_length_of   :content, :maximum => MAX_CHARS

  # =================================================================
  # PRIVATE =========================================================
  # =================================================================
  private

  ## Listing 12.44. Improving from_users_followed_by. 
  # Return an SQL condition for users followed by the given user.
  # We include the user's own id as well.
  def self.followed_by(user)
    ## Listing 12.45. The final implementation of
    ## from_users_followed_by.
    followed_ids = %(SELECT followed_id FROM relationships
                       WHERE follower_id = :user_id)
    { :conditions => ["user_id IN (#{followed_ids}) OR user_id = :user_id",
                      { :user_id => user }] }
  end
  
end
