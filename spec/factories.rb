# By using the symbol ':user', we get Factory Girl to simulate the User model.

Factory.define :user do |user|
  user.name                  "Michael Hartl"
  user.email                 "mhartl@example.com"
  user.password              "foobar"
  user.password_confirmation "foobar"
end

Factory.sequence :email do |n|
  "person-#{n}@example.com"
end

## Listing 11.8 We will need to construct some microposts in the User
## model spec, which means that we should make a micropost factory at
## this point. To do this, we need a way to make an association in
## Factory Girl. Happily, this is easy -- we just use the Factory Girl
## method micropost.association
Factory.define :micropost do |micropost|
  micropost.content "Foo bar"
  micropost.association :user
end
