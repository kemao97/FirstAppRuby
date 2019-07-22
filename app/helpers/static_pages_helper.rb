module StaticPagesHelper
  def full_header page_header = ""
    base_header = t "static_pages.base.header"
    if page_header.empty?
      base_header
    else
      base_header + "#" + page_header
    end
  end
end
