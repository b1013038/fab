# coding: utf-8

class PicController < ApplicationController
  def index
    #redirect_to :action => 'auth_user?'
    @pic = Paint.new
  end

  def show
    @pic = Paint.new
    @pic = Paint.where(["title = ? and userid = ?", URI.unescape(params[:title]), URI.unescape(params[:userid])])
    @pic = @pic.take
    send_file("public/img/#{@pic.title}.png", :disposition => 'inline')
  end

  def download
    @pic = Paint.new
    @pic = Paint.where(userid: params[:userid])
  end
  
  def create
    #params[:paint][:aaa]
    @pic = Paint.new
    @pic.userid = params[:userid]
    @pic.title = "#{params[:title]}_#{params[:userid]}" + Time.now.strftime("%y%m%H%M%S")
    file = Base64.decode64(params[:filedata])
    File.open("public/img/#{@pic.title}.png", 'wb') { |f|
      f.write(file)
    }
    file_path = URI.escape(params[:userid]) + '/' + URI.escape(@pic.title) + '.png'
    @pic.filedata = "http://paint.fablabhakodate.org/show/" + file_path
    @pic.category = params[:category]
    @pic.save
    redirect_to root_path
  end
  
  def convert
    @pic = Paint.new
    @pic = Paint.find(params[:id])
    filepath = "public/img/#{@pic.title}.png"
    @image = Magick::Image.read(@filename)[0]
    @image.format = "svg"
    @_png = @image.to_blob.to_s
    @_png = @_png.split(" cy=\""+(@image.rows - 1).to_s , 2)
    @_png.delete_at(-1)
    @str = @_png.join
    14.times{|f|
      @str.chop!
    }
    @str = @str + "</svg>"
    @_svg = Magick::Image.from_blob(@str)[0]
    @_svg.format = "pdf"
    @_pdf = @_svg.to_blob
    send_data(@_pdf, :type => "message/pdf", :filename => "convert.pdf", :disposition => 'attachment')
  end

  def to_blob
    
  end

  def auth_user
    if cookies[:_ryokutya_session].present?
      if session[:session_id] == cookies[:_ryokutya_session]
        if user = Login.find(kie: session[:data])
          self.current_user = user
        else
          self.current_user = nil
        end
      end
    end
  end
  
  def current_user=(user)
    @current_user = user
  end
  
  def login_user
    if user = Login.authenticate(params[:userid], params[:password])
      #if cookies[:_ryokutya_session] != user.kie
        Login.update(user.id, :kie => session[:data])
      self.current_user = user
    else
    #redirect_to 
    end
  end
  
  def logout_user
    Login.update(user.id, :kie => 1)
  end

  def add_user
    if Login.find_by_userid(params[:userid]) == nil && params[:userid] != nil && params[:password] != nil
      @user = Login.new
      @user.userid = params[:userid]
      @user.password = params[:password]
      @user.kie = cookies[:_ryokutya_session]
      @user.save
    end 
  end
  
  def icon
    @pic = Pic.all
    @pic.find(params[:id])
    send_data(Base64.decode64(@pic.filedata), :disposition => 'inline')
  end

  private
  def user_params
    params.require(:paint).permit(:title, :userid, :filedata, :category)
    param.require(:login).permit(:userid, :password_hash, :password_salt)
  end
end
