module ApplicationHelper
  def safe_controller_name
    params[:controller]
  end

  def safe_action_name
    "action_#{params[:action]}"
  end
end
