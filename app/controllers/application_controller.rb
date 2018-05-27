class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  before_action :set_session_variables

  def set_session_variables
    session[:games_won] ||= 0
    session[:games_lost] ||= 0
  end
end
