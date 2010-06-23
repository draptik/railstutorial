class MicropostsController < ApplicationController
  
  ## Listing 11.24 Adding authentication the the Microposts controller action
  before_filter :authenticate
  
  ## Listing 11.40 The Microposts controller destroy action. 
  before_filter :authorized_user, :only => :destroy

  ## Exercise 11.5.8 Add a nested route so that /users/1/microposts
  ## shows all the microposts for user 1. (You will also have to add a
  ## Microposts controller index action and corresponding view.)
  before_filter :find_user, :only => :index


  def create
    ## Listing 11.26 The Microposts controller create action
    @micropost  = current_user.microposts.build(params[:micropost])
    if @micropost.save
      flash[:success] = "Micropost created!"
      redirect_to root_path
    else
      ## Listing 11.37 There is one subtlety, though: on failed
      ## micropost submission, the Home page expects an @feed_items
      ## instance variable, so failed submissions currently break. The
      ## easiest solution is to suppress the feed entirely by
      ## assigning it an empty array.
      @feed_items = []
      render 'pages/home'
    end
  end

  ## Listing 11.40 The Microposts controller destroy action. 
  def destroy
    @micropost.destroy
    redirect_back_or root_path
  end

  ## Exercise 11.5.1 Character counter using JavaScript
  # def character_count
  #   respond_to do |format|
  #     format.js
  #   end
  # end
  
  ## Exercise 11.5.8 Add a nested route so that /users/1/microposts
  ## shows all the microposts for user 1. (You will also have to add a
  ## Microposts controller index action and corresponding view.)
  def index
    ## Adding a @microposts instance variable to the micropost index action. 
    @microposts = @user.microposts.paginate(:page => params[:page])
    @title = CGI.escapeHTML(@user.name)
  end

  # PRIVATE =========================================================
  private

  ## Listing 11.40 The Microposts controller destroy action. 
  def authorized_user
    @micropost = Micropost.find(params[:id])
    redirect_to root_path unless current_user?(@micropost.user)
  end

  ## Exercise 11.5.8 Add a nested route so that /users/1/microposts
  ## shows all the microposts for user 1. (You will also have to add a
  ## Microposts controller index action and corresponding view.)
  def find_user
    @user = User.find(params[:user_id])
  end

end
