class RelationshipsController < ApplicationController
  before_action :logged_in_user

  def create
    user = User.find_by id: params[:followed_id]
    if user
      current_user.follow user
    else
      flash[:danger] = t ".flash.danger"
    end
    redirect_to user
  end

  def destroy
    user = Relationship.find_by(id: params[:id]).followed
    if user
      current_user.unfollow user
    else
      flash.now[:danger] = t ".flash.danger"
    end
    redirect_to user
  end
end
