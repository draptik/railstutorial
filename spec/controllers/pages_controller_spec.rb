require 'spec_helper'

describe PagesController do 
  integrate_views

  before(:each) do
    @base_title = "Ruby on Rails Tutorial Sample App | "
  end

  describe "GET 'home'" do

    ## Listing 12.20. Testing the following/follower statistics on the
    ## Home page.
    describe "when not signed in" do

      before(:each) do
        get :home
      end

      it "should be successful" do
        response.should be_success
      end

      it "should have the right title" do
        response.should have_tag("title", @base_title + "Home")
      end
    end

    describe "when signed in" do

      before(:each) do
        @user = test_sign_in(Factory(:user))
        other_user = Factory(:user, :email => Factory.next(:email))
        other_user.follow!(@user)
      end

      it "should have the right follower/following counts" do
        get :home
        ## Using named routes to verify that the links have the right URLs.
        response.should have_tag("a[href=?]", following_user_path(@user), 
                                 /0 following/)
        response.should have_tag("a[href=?]", followers_user_path(@user), 
                                 /1 follower/)
      end
    end
    ## ------------------------------------------------------


    it "should be successful" do
      get :home
      response.should be_success
    end

    it "It should have the right title" do
      get :home
      response.should have_tag("title",
                               @base_title + "Home")
    end

    ## Exercise 11.5.4 Add tests for micropost pagination
    it "should paginate microposts" do

      # Login a valid user and create microposts
      @user = test_sign_in(Factory(:user))
      @micropost = Factory(:micropost, :user => @user)

      # Create 30 microposts
      30.times { Factory(:micropost, :user => @user) }
      get :home

      # Check pagination controls
      response.should have_tag("div.pagination")
      response.should have_tag("span", "&laquo; Previous")
      response.should have_tag("span", "1")
      response.should have_tag("a[href=?]", "/?page=2", "2")
      response.should have_tag("a[href=?]", "/?page=2", "Next &raquo;")
    end

    ## Exercise 11.5.6 Test to make sure delete links do not appear
    ## for microposts not created by the current user
    describe "Display delete link" do

      before(:each) do
        # Login a valid user
        @user = test_sign_in(Factory(:user))
        
        # Create another user
        @attr = { :name => "New User",
          :email => "user@example.com",
          :password => "foobar",
          :password_confirmation => "foobar" }
        @other_user = Factory(:user, @attr)
      end

      describe "failure" do
        
        before(:each) do
          @other_micropost = Factory(:micropost, :user => @other_user)
          30.times { Factory(:micropost, :user => @other_user) }
        end
        
        it "should not have a delete link for another user" do
          get :home, :id => @other_user
          response.should_not have_tag("span.action")
        end
      end
      
      describe "success" do
        
        before(:each) do
          @micropost = Factory(:micropost, :user => @user)
          30.times { Factory(:micropost, :user => @user) }
        end

        it "should have a delete link for a current user" do
          get :home, :id => @user
          response.should have_tag("span.action")
        end
      end
    end
  end


  describe "GET 'contact'" do
    it "should be successful" do
      get :contact
      response.should be_success
    end

    it "It should have the right title" do
      get 'contact'
      response.should have_tag("title",
                               @base_title + "Contact")
    end
  end

  describe "Get 'about'" do
    it "sould be successful" do
      get :about
      response.should be_success
    end

    it "It should have the right title" do
      get :about
      response.should have_tag("title",
                               @base_title + "About")
    end
  end
end
