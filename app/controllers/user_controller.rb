class UserController < ApplicationController
  skip_before_filter :check_authentication, :only => "login"
  
  def login
    if request.post?
      user=User.find(:first, :conditions => ['username = ?', params[:username]])
      if user.blank? || !user.test_password(params[:password])
        session[:user] = nil
        flash[:notice] = 'Username or password invalid'
      else
        session[:user] = user.id
        redirect_to :controller => session[:intended_controller],
                    :action => session[:intended_action]
      end
    end
  end
  
  def logout
    session[:user] = nil
    redirect_to '/'
  end
end
