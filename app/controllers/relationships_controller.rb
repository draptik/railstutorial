## Listing 12.32. The Relationships controller. 
class RelationshipsController < ApplicationController
  before_filter :authenticate
  before_filter :get_followed_user

  def create
    current_user.follow!(@user)

    ## Listing 12.37. Responding to Ajax requests in the Relationships
    ## controller.
    respond_to do |format|
      format.html { redirect_to @user }
      format.js
    end
  end

  def destroy
    current_user.unfollow!(@user)

    ## Listing 12.37. Responding to Ajax requests in the Relationships
    ## controller.
    respond_to do |format|
      format.html { redirect_to @user }
      format.js
    end
  end

  # =================================================================
  # PRIVATE =========================================================
  # =================================================================
  private

    def get_followed_user
      @user = User.find(params[:relationship][:followed_id])
    end
end
