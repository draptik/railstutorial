# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper

  def logo
    logo = image_tag("logo.png", :alt => "Sample App", :class => "round")
  end

  def title
    base_title = "Ruby on Rails Tutorial Sample App"
    if @title.nil?
      base_title
    else
      "#{base_title} | #{h(@title)}"
    end
  end

  ## Exercise 11.5.1
  def warn_if_word_count_exceeded(field_id, update_id, maximum_number_of_words, options = {})
    ##
    ## URL for wordcount: http://stufftohelpyouout.blogspot.com/2009/09/rubyrails-and-javascript-word-count.html
    ##
    # function = "var words = []; $F('#{field_id}').scan(/\\w+/, function(match){ words.push(match[0]) }); if (words.length > #{maximum_number_of_words}) { $('#{update_id}').innerHTML = 'Your entry contains ' + words.length + ' words. Please limit your answer to #{maximum_number_of_words} words.' } else { $('#{update_id}').innerHTML = '' };" 
    ##
    ## URL for basic char count: http://www.swards.net/2009/05/character-count-textarea-in-ruby-on.html
    ##
    function = "$('#{update_id}').innerHTML = $F('#{field_id}').length;"
    out = javascript_tag(function)
    out += observe_field(field_id, options.merge(:function => function))
  end
  
  ## Exercise 11.5.1
  def warn_if_char_count_exceeded(field_id, update_id, maximum_number_of_chars, options = {})

    ## 1. Simple counter ------------------------------------------------
    #     function = "var remaining_chars = $(#{maximum_number_of_chars}) - $F('#{field_id}').length; 
    # $('#{update_id}').innerHTML = remaining_chars;"
    
    ## 2. Countdown with red background if count is exceeded ------------
    function = "var out = []; 
var remaining_chars = $(#{maximum_number_of_chars}) - $F('#{field_id}').length; 
if (remaining_chars >= 0) { 
    out = remaining_chars; 
    document.getElementById('#{field_id}').style.backgroundColor='white' 
  } else { 
    out = 'Too long by ' + remaining_chars; 
    document.getElementById('#{field_id}').style.backgroundColor='red' 
  }
  $('#{update_id}').innerHTML = out;"

    out = javascript_tag(function)
    out += observe_field(field_id, options.merge(:function => function))
  end


end
