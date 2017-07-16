# Filters added to this controller will be run for all controllers in the application.
# Likewise, all the methods added will be available for all controllers.
class ApplicationController < ActionController::Base
  before_filter :check_authentication
  
  def check_authentication
    unless session[:user]
      session[:intended_action] = action_name
      session[:intended_controller] = controller_name
      redirect_to :controller => "user", :action => "login"
    end
  end
  
  def get_anaesthetists(called='')
    Anaesthetist.find(:all,
      :conditions => ['surname LIKE ?', called + '%'],
      :order => 'surname ASC',
      :limit => 10)
  end
  
  def get_consultant_anaesthetists(called='')
    Anaesthetist.find(:all,
      :conditions => ['surname LIKE ? AND consultant == ?', called + '%', 't'],
      :order => 'surname ASC',
      :limit => 10)
  end
end