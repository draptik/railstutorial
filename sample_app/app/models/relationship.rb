# == Schema Information
# Schema version: 20100618213205
#
# Table name: relationships
#
#  id          :integer         not null, primary key
#  follower_id :integer
#  followed_id :integer
#  created_at  :datetime
#  updated_at  :datetime
#

class Relationship < ActiveRecord::Base

  ## Listing 12.2 Making a relationship's followed_id (but not
  ## follower_id) accessible.
  attr_accessible :followed_id

  ## Adding the belongs_to associations to the Relationship model.
  belongs_to :follower, :foreign_key => "follower_id", :class_name => "User"
  belongs_to :followed, :foreign_key => "followed_id", :class_name => "User"

  ## Listing 12.9. Adding the Relationship model validations.
  validates_presence_of :follower_id, :followed_id
  
end
