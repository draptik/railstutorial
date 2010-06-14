module MicropostsHelper

  def display(content)
    auto_link(sanitize(content))
  end
end
