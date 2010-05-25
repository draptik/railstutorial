## Listing 11.4
require 'spec_helper'

describe Micropost do

  before(:each) do
    ## We use a factory user because these tests are for the Micropost
    ## model, not the User model.
    @user = Factory(:user)
    @attr = { :content => "value of content" }
  end

  it "should create a new instance given valid attributes" do
    @user.microposts.create!(@attr)
  end

  describe "user associations" do

    before(:each) do
      @micropost = @user.microposts.create(@attr)
    end 

    it "should have a user attribute" do
      @micropost.should respond_to(:user)
    end

    it "should have the right associated user" do
      @micropost.user_id.should == @user.id
      @micropost.user.should == @user
    end
  end
end
