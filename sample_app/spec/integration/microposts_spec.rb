require 'spec_helper'

describe "Microposts" do

  ## Listing 11.41 An integration test for the microposts on the home page
  before(:each) do
    @user = Factory(:user)
    visit signin_path
    fill_in :email,    :with => @user.email
    fill_in :password, :with => @user.password
    click_button
  end

  describe "creation" do

    describe "failure" do

      it "should not make a new micropost with empty content" do
        lambda do
          visit root_path
          click_button
          response.should render_template('pages/home')
          response.should have_tag("div#errorExplanation")
        end.should_not change(Micropost, :count)
      end
    end

    describe "success" do

      it "should make a new micropost" do
        content = "Lorem ipsum dolor sit amet"
        lambda do
          visit root_path
          fill_in :micropost_content, :with => content
          click_button
          response.should have_tag("span.content", content)
        end.should change(Micropost, :count).by(1)
      end
    end
  end

  describe "destruction" do

    it "should destroy a micropost" do
      # Create a micropost.
      visit root_path
      fill_in :micropost_content, :with => "lorem ipsum"
      click_button
      # Destroy it.
      lambda { click_link "delete" }.should change(Micropost, :count).by(-1)
    end
  end

  ## Ecercise 11.5.2 Add tests for the sidebar micropost counts
  ## (including proper pluralization).
  describe "side bar content" do

    it "should contain the micropost sidebar (with elements)" do
      # Create a single micropost.
      visit root_path
      fill_in :micropost_content, :with => "lorem ipsum"
      click_button
      response.should have_tag("img.gravatar")
      response.should have_tag("span.user_name")
      response.should have_tag("span.microposts")
    end

    it "should contain a single micropost with correct pluralization" do
      # Create a single micropost.
      visit root_path
      fill_in :micropost_content, :with => "lorem ipsum"
      click_button
      response.should_not have_tag("span.microposts", "microposts")  # plural
      response.should have_tag("span.microposts", /1 micropost/)     # singular
    end

    it "should contain 2 microposts with correct pluralization" do
      # Create two microposts.
      visit root_path
      fill_in :micropost_content, :with => "lorem ipsum"
      click_button
      visit root_path
      fill_in :micropost_content, :with => "lorem ipsum2"
      click_button
      response.should_not have_tag("span.microposts", "micropost")  # singular
      response.should have_tag("span.microposts", "2 microposts")   # plural
    end
  end
end
