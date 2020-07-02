class PasswordResetsController < ApplicationController
  before_action :load_user, :valid_user, :check_expiration,
    only: [:edit, :update]

  def new; end

  def create
    @user = User.find_by email:
      params[:password_reset][:email].downcase
    if @user
      @user.create_reset_digest
      @user.send_password_reset_email
      flash[:info] = t "reset_pass.info"
      redirect_to root_url
    else
      flash.now[:danger] = t "reset_pass.danger"
      render :new
    end
  end

  def update
    if user_params[:password].blank?
      flash.now[:fail] =
        @user.errors.add(:password, t( "reset_pass.blank" ))
      render :edit
    elsif @user.update_attributes user_params
      log_in @user
      flash[:success] = t "reset_pass.success"
      redirect_to @user
    else
      render :edit
    end
  end

  def edit; end

  private

  def load_user
    @user = User.find_by email: params[:email]
    return if @user

    flash[:warning] = t "reset_pass.warning"
    redirect_to root_url
  end

  def user_params
    params.require(:user).permit :password, :password_confirmation
  end

  def valid_user
    authenticated = @user.authenticated?(:reset, params[:id])
    return if @user.activated? && authenticated

    flash[:warning] = t "reset_pass.warning_1"
    redirect_to root_url
  end

  def check_expiration
    if @user.password_reset_expired?
      flash[:danger] = t "reset_pass.danger_2"
      redirect_to new_password_reset_url
    end
  end
end
