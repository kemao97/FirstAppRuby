module ApplicationHelper
  def full_page page_title = ""
    base_title = t "layouts.application.title"
    if page_title.empty?
      base_title
    else
      page_title + " | " + base_title
    end
  end
end
