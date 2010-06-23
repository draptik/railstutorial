# == Schema Information
# Schema version: 20100618213205
#
# Table name: microposts
#
#  id         :integer         not null, primary key
#  content    :string(255)
#  user_id    :integer
#  created_at :datetime
#  updated_at :datetime
#

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

  ## Listing 11.13 Tests for the Micropost model validations
  describe "validations" do

    it "should require a user id" do
      Micropost.new(@attr).should_not be_valid
    end

    it "should require nonblank content" do
      ## "@user.microposts.build" is essentially equivalent to
      ## Micropost.new, except that it automatically sets the
      ## micropost's user_id to @user.id
      @user.microposts.build(:content => "  ").should_not be_valid
    end

    it "should reject long content" do
      @user.microposts.build(:content => "a" * 141).should_not be_valid
    end
  end

end
