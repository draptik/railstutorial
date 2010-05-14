require 'spec_helper'

describe SessionsController do
  integrate_views


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

  end # "POST create"

end
