# == Schema Information
# Schema version: 20100618213205
#
# Table name: relationships
#
#  id          :integer         not null, primary key
#  follower_id :integer
#  followed_id :integer
#  created_at  :datetime
#  updated_at  :datetime
#

require 'spec_helper'

describe Relationship do

  before(:each) do
    ## Listing 12.3 Testing relationship creation with save!
    @follower = Factory(:user)
    @followed = Factory(:user, :email => Factory.next(:email))

    @relationship = @follower.relationships.build(:followed_id => @followed.id)
  end

  it "should create a new instance given valid attributes" do
    @relationship.save!
  end

  ## Listing 12.6. Testing the user/relationships belongs_to
  ## association.
  describe "follow methods" do

    before(:each) do
      @relationship.save
    end

    it "should have a follower attribute" do
      @relationship.should respond_to(:follower)
    end

    it "should have the right follower" do
      @relationship.follower.should == @follower
    end

    it "should have a followed attribute" do
      @relationship.should respond_to(:followed)
    end

    it "should have the right followed user" do
      @relationship.followed.should == @followed
    end
  end

  ## Listing 12.8. Testing the Relationship model validations.
  describe "validations" do

    it "should reqire a follower_id" do
      @relationship.follower_id = nil
      @relationship.should_not be_valid
    end

    it "should reqire a followed_id" do
      @relationship.followed_id = nil
      @relationship.should_not be_valid
    end
  end

  ## Exercise 12.5.1 Add tests for dependent :destroy in the
  ## Relationship model (Listing 12.5 and Listing 12.17) by following
  ## the example in Listing 11.11.
  it "should destroy associated relationships" do
    @relationship.save
    Relationship.find_by_id(@relationship.id) == @relationship.id
    @relationship.destroy
    Relationship.find_by_id(@relationship.id).should be_nil
  end
end
