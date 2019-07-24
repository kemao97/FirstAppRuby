class PasswordResetsController < ApplicationController
  before_action only: %i(edit update) do
    get_user
    valid_user
    check_expiration
  end

  def new; end

  def create
    @user = User.find_by email: params[:password_reset][:email].downcase
    if @user
      @user.create_reset_digest
      @user.send_password_reset_email
      flash[:info] = t ".flash.info"
      redirect_to root_url
    else
      flash.now[:danger] = t ".flash.danger"
      render :new
    end
  end

  def edit; end

  def update
    if params[:user][:password].empty?
      @user.errors.add :password, t(".password_empty")
      render :edit
    elsif @user.update user_params
      log_in @user
      @user.update reset_digest: nil
      flash[:success] = t ".flash.success"
      redirect_to @user
    else
      render :edit
    end
  end

  private

  def user_params
    params.require(:user).permit :password, :password_confirmation
  end

  def get_user
    @user = User.find_by email: params[:email]
    return @user if @user
    render file: "public/404.html", status: :not_found
  end

  def valid_user
    return if @user&.activated? && @user.authenticated?(:reset, params[:id])
    redirect_to root_url
  end

  def check_expiration
    return unless @user.password_reset_expired?
    flash[:danger] = t ".flash.danger"
    redirect_to new_password_reset_url
  end
end
