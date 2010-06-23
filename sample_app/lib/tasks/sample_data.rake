# -*- coding: utf-8 -*-
## Listing 10.23
require 'faker'

namespace :db do

  ## This defines a task db:populate that resets the development
  ## database using db:reset (using slightly weird syntax you
  ## shouldn’t worry about too much), creates an example user with
  ## name and email address replicating our previous one, and then
  ## makes 99 more.
  desc "Fill database with sample data"
  task :populate => :environment do
    Rake::Task['db:reset'].invoke

    ## Listing 12.18 Adding following/follower relationships to the
    ## sample data.
    make_users
    make_microposts
    make_relationships
  end
end


## Listing 12.18 Adding following/follower relationships to the
## sample data.
def make_users
  
  ## Listing 10.35 ("admin")
  admin = User.create!(:name => "Example User",
                       :email => "example@railstutorial.org",
                       :password => "foobar",
                       :password_confirmation => "foobar")
  ## Listing 10.35
  admin.toggle!(:admin)

  99.times do |n|
    name  = Faker::Name.name
    email = "example-#{n+1}@railstutorial.org"
    password  = "password"
    User.create!(:name => name,
                 :email => email,
                 :password => password,
                 :password_confirmation => password)
  end
end


## Listing 12.18 Adding following/follower relationships to the
## sample data.
def make_microposts

  ## Listing 11.20 Adding microposts to the sample data
  User.all(:limit => 6).each do |user|
    50.times do
      user.microposts.create!(:content => Faker::Lorem.sentence(5))
    end
  end
end


## Listing 12.18 Adding following/follower relationships to the
## sample data.
##
## We somewhat arbitrarily arrange for the first user to follow the
## next 50 users, and then have users with ids 3 through 40 follow
## that user back. The resulting relationships will be sufficient for
## developing the application interface.
def make_relationships
  users = User.all
  user  = users.first
  following = users[1..50]
  followers = users[3..40]
  following.each { |followed| user.follow!(followed) }
  followers.each { |follower| follower.follow!(user) }
end
