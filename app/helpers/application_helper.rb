module ApplicationHelper
  def format_url(url)
    url.starts_with?("http://") ? url : "http://#{url}"
  end
  def format_date(date)
    date.strftime("%m/%d/%Y %l:%M%P %Z") 
  end
end
