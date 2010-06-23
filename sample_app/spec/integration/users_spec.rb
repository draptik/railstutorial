require 'spec_helper'

describe "Users" do

  describe "signup" do

    describe "failure" do

      ## This is an integration test!
      it "should not make a new user" do
        lambda do
          visit signup_url
          click_button
          response.should render_template('users/new')
          response.should have_tag("div#errorExplanation")
        end.should_not change(User, :count)
      end
    end

    describe "success" do

      it "should make a new user" do
        lambda do
          visit signup_url
          fill_in "Name", :with => "Example User"
          fill_in "Email", :with => "user@example.com"
          fill_in "Password", :with => "foobar"
          fill_in "confirmation", :with => "foobar"
          click_button
          response.should render_template('users/show')
          response.should have_tag("div.flash.success")
        end.should change(User, :count).by(1)
      end

    end


    describe "sign in/out" do

      describe "failure" do
        it "should not sign a user in" do
          visit signin_path
          fill_in :email, :with => ""
          fill_in :password, :with => ""
          click_button
          response.should render_template('sessions/new')
          response.should have_tag("div.flash.error", /invalid/i)
        end
      end

      describe "success" do
        it "should sign a user in and out" do
          user = Factory(:user)
          visit signin_path
          fill_in :email,    :with => user.email
          fill_in :password, :with => user.password
          click_button
          controller.should be_signed_in
          click_link "Sign out"
          controller.should_not be_signed_in
        end
      end
    end # "sign in/out"

  end

  ## Exercise 12.5.5 Write an integration test for following and
  ## unfollowing a user.
  describe "follow/unfollow" do

    before(:each) do
      ## Sign in
      @user = Factory(:user)
      visit signin_path
      fill_in :email,    :with => @user.email
      fill_in :password, :with => @user.password
      click_button

      @other_user = Factory(:user, :email => Factory.next(:email))
    end

    it "should not be following anybody" do
      response.should_not have_tag("div.stats", /1 following/)
      response.should have_tag("div.stats", /0 following/)
    end

    it "should not have any followers" do
      response.should_not have_tag("div.stats", /1 follower/)
      response.should have_tag("div.stats", /0 follower/)
    end

    it "should follow and then unfollow another user" do

      ## Visit another user's profile
      visit 'users/' + @other_user.id.to_s
      response.should have_tag("title", /#{@other_user.name}/)
      
      ## Click the follow button
      click_button "Follow"

      ## Confirm result ---------------------------------------
      ## Check users following stats (should be 1)
      visit 'users/' + @user.id.to_s
      response.should have_tag("title", /#{@user.name}/)
      response.should have_tag("div.stats", /1 following/)
      response.should_not have_tag("div.stats", /0 following/)

      ## Check other users followers stats (should be 1)
      visit 'users/' + @other_user.id.to_s
      response.should have_tag("title", /#{@other_user.name}/)
      response.should have_tag("div.stats", /1 follower/)
      response.should_not have_tag("div.stats", /0 followers/)

      ## Click unfollow button
      click_button "Unfollow"

      ## Confirm result ---------------------------------------
      ## Check users following stats (should be 0)
      visit 'users/' + @user.id.to_s
      response.should have_tag("title", /#{@user.name}/)
      response.should_not have_tag("div.stats", /1 following/)
      response.should have_tag("div.stats", /0 following/)

      ## Check other users followers stats (should be 0)
      visit 'users/' + @other_user.id.to_s
      response.should have_tag("title", /#{@other_user.name}/)
      response.should_not have_tag("div.stats", /1 follower/)
      response.should have_tag("div.stats", /0 followers/)
    end
  end
end
