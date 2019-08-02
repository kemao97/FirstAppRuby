class StaticPagesController < ApplicationController
  def help; end

  def home
    return unless logged_in?
    @micropost  = current_user.microposts.build
    @feed_items = current_user.feed.order_time_desc.page params[:page]
  end

  def about; end

  def contact; end
end
