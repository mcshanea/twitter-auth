class EditionsController < ApplicationController
  def opf
  end

  def ncx
  end

  def ebook
  	@user = User.find(params[:id])
  end

end
