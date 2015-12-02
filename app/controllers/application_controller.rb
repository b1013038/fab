class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  #protect_from_forgery with: :exception
  #include ::SslRequirement
  #protect_from_forgery with: :null_session
  skip_before_action :verify_authenticity_token

  def current_user
    if session[:session_id]
      @current_user ||= Login.find_by_kie(session[:session_id])
    end
  end
  
  def current_user=(user)
    @current_user = user
  end
  
  def logged_in?
    current_user != nil
  end

  helper_method :current_user, :logged_in?
end
