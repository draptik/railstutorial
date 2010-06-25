# -*- coding: utf-8 -*-
module MicropostsHelper

  ## Exercise 11.5.7 Define a display helper using the sanitize and
  ## auto_link methods, as shown in Listing 11.42, and use it to
  ## replace the h method in the micropost partial (Listing
  ## 11.17). Examine the results for a micropost whose content
  ## includes a URL (such as “I'm reading an awesome Rails book at
  ## http://www.railstutorial.org/!”).
  def display(content)
    auto_link(sanitize(wrap(content)))
  end


  ## Exercise 11.5.9 Very long words currently break our layout, as
  ## shown in Figure 11.17. Fix this problem using the wrap helper
  ## defined in Listing 11.43
  ##
  ## Listing 11.43
  def wrap(content)
    content.split.map{ |s| wrap_long_string(s) }.join(' ')
  end

  private

  def wrap_long_string(text, max_width = 30)
    zero_width_space = "&#8203;"
    regex = /.{1,#{max_width}}/
    (text.length < max_width) ? text : text.scan(regex).join(zero_width_space)
  end
end
