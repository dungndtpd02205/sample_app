class SessionsController < ApplicationController
  def new; end

  def create
    user = User.find_by email: params[:session][:email].downcase
    if user&.authenticate(params[:session][:password])
      if user.activated?
        log_in user
        remember_param = params[:session][:remember_me]
        remember_param == "1" ? remember(user) : forget(user)
        redirect_back_or user
      else
        flash[:warning] = t "mail.warning"
        redirect_to root_url
      end
    else
      flash.now[:danger] = t "login.attr.message_fail"
      render :new
    end
  end

  def destroy
    log_out if logged_in?
    redirect_to root_url
  end
end
