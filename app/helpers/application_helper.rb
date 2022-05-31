module ApplicationHelper

  def provide_title(title = "")
    base_title = "Ruby on Rails Tutorial Sample App"
    title.empty? ? "#{base_title}" : "#{title} | #{base_title}"
  end
  
end
