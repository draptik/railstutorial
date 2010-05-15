require 'spec_helper'

describe SessionsController do
  integrate_views


  # GET NEW =========================================================
  describe "GET 'new'" do

    it "should be successful" do
      get :new
      response.should be_success
    end

    it "should have the right title" do
      get :new
      response.should have_tag("title", /sign in/i)
    end

  end # GET new

  # POST CREATE =====================================================
  describe "POST 'create'" do

    describe "invalid signin" do

      before(:each) do
        @attr = { :email => "email@example.com", :password => "password" }
        User.should_receive(:authenticate). # User model receives "authenticate" method...
          with(@attr[:email], @attr[:password]). # ...with email and password.
          and_return(nil) # ".and_return(...)" is a guarantee, not an expectation!
      end

      it "should re-render the new page" do
        post :create, :session => @attr
        response.should render_template('new')
      end

      it "should have the right title" do
        post :create, :session => @attr
        response.should have_tag("title", /sign in/i)
      end

    end # "invalid signin"

    describe "with valid email and password" do

      before(:each) do
        @user = Factory(:user)
        @attr = { :email => @user.email, :password => @user.password }
        User.should_receive(:authenticate).
          with(@user.email, @user.password).
          and_return(@user)
      end

      it "should sign the user in" do
        post :create, :session => @attr
        controller.current_user.should == @user
        controller.should be_signed_in
        ## The previous line is equivalent to: controller.signed_in?.should be_true
      end

      it "should redirect to the user show page" do
        post :create, :session => @attr
        redirect_to user_path(@user)
      end

    end 

  end # "POST create"

  # DELETE DESTROY ==================================================
  describe "DELETE 'destroy'" do

    it "should sign a user out" do
      test_sign_in(Factory(:user))
      controller.should be_signed_in
      delete :destroy
      controller.should_not be_signed_in
      response.should redirect_to(root_path)
    end

  end # "DELETE 'destroy'"

end
