class UsersController < ApplicationController
  before_action :logged_in_user, except: [:new, :create, :show]
  before_action :load_user, except: [:new, :create, :index]
  before_action :correct_user, only: [:edit, :update]
  before_action :admin_user, only: :destroy

  def new
    @user = User.new
  end

  def show
    @microposts = @user.microposts.paginate(page: params[:page])
  end

  def create
    @user = User.new(user_params)
    if @user.save
      @user.send_activation_email
      flash[:info] = t "mail.info"
      redirect_to root_url
    else
      render :new
    end
  end

  def index
    @users = User.active.paginate(page: params[:page])
  end

  def update
    if @user.update user_params
      flash[:success] = t "edit_attr.mess"
      redirect_to @user
    else
      render :edit
    end
  end

  def edit; end

  def destroy
    if @user.destroy
      flash[:success] = t "delete.mess"
      redirect_to users_url
    else
      flash[:fail] = t "delete.fails"
      redirect_to root_url
    end
  end

  private

  def user_params
    params
      .require(:user)
      .permit(:name, :email, :password, :password_confirmation)
  end

  def correct_user
    unless current_user? @user
      flash[:warning] = t "edit_attr.warning"
      redirect_to root_url
    end
  end

  def admin_user
    redirect_to root_url unless current_user.admin?
  end

  def load_user
    @user = User.find_by id: params[:id]
    return if @user
    flash[:warning] = t("sigup_attr.warning_mess", id: params[:id])
    redirect_to root_url
  end
end
