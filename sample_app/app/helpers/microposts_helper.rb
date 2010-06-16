# -*- coding: utf-8 -*-
module MicropostsHelper

  ## Exercise 11.5.7 Define a display helper using the sanitize and
  ## auto_link methods, as shown in Listing 11.42, and use it to
  ## replace the h method in the micropost partial (Listing
  ## 11.17). Examine the results for a micropost whose content
  ## includes a URL (such as “I'm reading an awesome Rails book at
  ## http://www.railstutorial.org/!”).
  def display(content)
    auto_link(sanitize(content))
  end
end
