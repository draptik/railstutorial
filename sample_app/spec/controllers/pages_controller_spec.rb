require 'spec_helper'

describe PagesController do 
  integrate_views

  before(:each) do
    @base_title = "Ruby on Rails Tutorial Sample App | "
  end

  describe "GET 'home'" do
    it "should be successful" do
      get 'home'
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
      get 'contact'
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
      get 'about'
      response.should be_success
    end

    it "It should have the right title" do
      get 'about'
      response.should have_tag("title",
                               @base_title + "About")
    end
  end

end
