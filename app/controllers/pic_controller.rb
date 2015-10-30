class PicController < ApplicationController
  def index
    @pic = Paint.new
  end

  def show
    @pic = Paint.all
    # @pic = find(params[:userid])
    #send_data(Base64.decode64(Paint.find(:id).filedata), :type => 'image/png', :disposition => 'inline')
  end

  def download
  end

  def create
  @pic = Paint.new
  @pic.userid = params[:paint][:userid]
  @pic.title = params[:paint][:title]
  @pic.save
  redirect_to '/pic/download'
  end
  
  def icon
    @pic = Paint.find(24)
    send_data(Base64.decode64(@pic.filedata), :type => 'image/png', :disposition => 'inline')
  end
  private
  def user_params
    params.require(:paint).permit(:title, :userid, :filedata, :category)
    param.require(:login).permit(:userid, :mysign)
  end
end
