module ApplicationHelper
  include Pagy::Frontend

  def authenticate_admin_role
    current_user && (current_user.Admin? || current_user.Super_Admin?)
  end

  def format_date(post)
    if post.hide_day && post.hide_month
      post.date.strftime("%Y") 
    elsif post.hide_day
      post.date.strftime("%b %Y")  
    elsif post.hide_month
      post.date.strftime("%d %Y")  
    else
      post.date.strftime("%d %b %Y")
    end
  end
end
