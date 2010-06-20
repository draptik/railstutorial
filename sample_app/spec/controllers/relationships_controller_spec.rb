require 'spec_helper'

## Listing 12.31. Tests for the Relationships controller actions. 
describe RelationshipsController do

  describe "access control" do
    it "should require signin for create" do
      post :create
      response.should redirect_to(signin_path)
    end

    it "should require signin for destroy" do
      delete :destroy
      response.should redirect_to(signin_path)
    end
  end

  describe "POST 'create'" do

    before(:each) do
      @user = test_sign_in(Factory(:user))
      @followed = Factory(:user, :email => Factory.next(:email))

      @user.should_receive(:follow!).with(@followed)
    end

    it "should create a relationship" do
      post :create, :relationship => { :followed_id => @followed }
      response.should be_redirect
    end

    ## Listing 12.35. Tests for the Relationships controller responses
    ## to Ajax requests.
    it "should respond to an Ajax request" do
      xhr :post, :create, :relationship => { :followed_id => @followed }
      response.should be_success
    end
  end

  describe "DELETE 'destroy'" do

    before(:each) do
      @user = test_sign_in(Factory(:user))
      @followed = Factory(:user, :email => Factory.next(:email))

      @user.should_receive(:unfollow!).with(@followed)
    end

    it "should destroy a relationship" do
      delete :destroy, :relationship => { :followed_id => @followed }
      response.should be_redirect
    end

    ## Listing 12.35. Tests for the Relationships controller responses
    ## to Ajax requests.
    it "should respond to an Ajax request" do
      xhr :delete, :destroy, :relationship => { :followed_id => @followed }
      response.should be_success
    end
  end
end
