class HomeController < ApplicationController
  def index
  end

  def handler
  	user = User.find(params[:id])
  	user.async_create_edition
  end
end
