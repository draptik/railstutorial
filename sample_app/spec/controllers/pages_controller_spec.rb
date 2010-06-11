require 'spec_helper'

describe PagesController do 
  integrate_views

  before(:each) do
    @base_title = "Ruby on Rails Tutorial Sample App | "
  end

  describe "GET 'home'" do
    it "should be successful" do
      get :home
      response.should be_success
    end

    it "It should have the right title" do
      get 'home'
      response.should have_tag("title",
                               @base_title + "Home")
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

  ## Exercise 11.5.4 Add tests for micropost pagination
  describe "GET 'home'" do

    before(:each) do
      @user = test_sign_in(Factory(:user))
      @micropost = Factory(:micropost, :user => @user)
    end

    it "should paginate microposts" do
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
  end


end
