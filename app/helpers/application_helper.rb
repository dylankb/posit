module ApplicationHelper
  def format_url(url)
    url.starts_with?("http://") ? url : "http://#{url}"
  end

  def format_date(date)
    if logged_in? && !current_user.time_zone.blank?
      date.in_time_zone(current_user.time_zone).strftime("%m/%d/%Y %l:%M%P %Z")
    else
      date.strftime("%m/%d/%Y %l:%M%P %Z")
    end
  end

  def ajax_flash_message(element_id)
    flash_div = ""

    flash.each do |name, msg|
      if msg.is_a?(String)
        flash_div = "<div class=\"alert alert-#{name == :notice ? 'success' : 'error'} ajax_flash\"><a class=\"close\" data-dismiss=\"alert\">&#215;</a> <div id=\"flash_#{name == :notice ? 'notice' : 'error'}\">#{msg}</div> </div>"
      end
    end

    response = "$('.ajax_flash').remove();$('#{element_id}').prepend('#{flash_div}');"
    response.html_safe
  end
end
