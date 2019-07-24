class UsersController < ApplicationController
  before_action :logged_in_user, except: %i(show create new)
  before_action :user_modify, except: %i(index create new)
  before_action :correct_user, only: %i(edit update)
  before_action :admin_user, only: %i(destroy)

  def index
    @users = User.page(params[:page]).per Settings.controllers.users.index.per_page
  end

  def show; end

  def new
    @user = User.new
  end

  def create
    @user = User.new user_params
    if @user.save
      log_in @user
      @user.send_activation_email
      flash[:info] = t ".flash.info"
      redirect_to @user
    else
      render :new
    end
  end

  def edit; end

  def update
    if @user.update user_params
      flash[:success] = t ".flash.success"
      redirect_to @user
    else
      render :edit
    end
  end

  def destroy
    if @user.destroy
      flash[:success] = t ".flash.success"
    else
      flash[:danger] = t ".flash.danger"
    end
    redirect_to users_url
  end

  private

  def user_modify
    @user = User.find_by id: params[:id]
    return @user if @user
    render file: "public/404.html", status: :not_found
  end

  def logged_in_user
    return if logged_in?
    flash[:danger] = t ".danger"
    redirect_to login_url
  end

  def user_params
    params.require(:user).permit :name, :email, :password, :password_confirmation
  end

  def admin_user
    redirect_to root_url unless current_user.admin?
  end

  def correct_user
    redirect_to root_url unless current_user? user_modify
  end
end
