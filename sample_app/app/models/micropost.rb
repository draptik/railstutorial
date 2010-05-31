# == Schema Information
# Schema version: 20100523162612
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

  ## Exercise 11.5.1
  MAX_CHARS = 140

  ## Listing 11.14 The Micropost model validations
  validates_presence_of :content, :user_id
  validates_length_of   :content, :maximum => MAX_CHARS

end
