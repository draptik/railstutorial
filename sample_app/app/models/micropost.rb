class Micropost < ActiveRecord::Base
  ## Listing 11.2 Making the content attribute (and only the content
  ## attribute) accessible. 
  ##
  ## Since user_id *isn't* listed as an attr_accessible parameter, it
  ## *can't* be edited through the web.
  attr_accessible :content

  ## Listing 11.6
  belongs_to :user
  
end
