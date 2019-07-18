class StaticPagesController < ApplicationController

  def home
    render layout: false
  end

  def help
    render layout: false
  end

  def about
    render layout: false
  end
end
