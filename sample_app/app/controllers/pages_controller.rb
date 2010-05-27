class PagesController < ApplicationController

  def home
    @title = "Home"
    # ## Listing 11.30 Adding a micropost instance variable to the home action
    # @micropost = Micropost.new if signed_in?
    ## Listing 11.33 Adding a feed instance variable to the home action
    if signed_in?
      @micropost = Micropost.new
      @feed_items = current_user.feed.paginate(:page => params[:page])
    end
  end

  def contact
    @title = "Contact"
  end

  def about
    @title = "About"
  end
end
