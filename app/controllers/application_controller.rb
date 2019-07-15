class ApplicationController < ActionController::Base

  def index
    render html: "hello world"
  end

end
