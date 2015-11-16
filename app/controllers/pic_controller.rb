# coding: utf-8

class PicController < ApplicationController
  helper_method :current_user, :logged_in?

  def index
    #redirect_to :action => 'auth_user?'
    @pic = Paint.new
  end

  def show
    pic = Paint.new
#    @pic = Paint.where(["title = ? and userid = ?", URI.unescape(params[:title]), URI.unescape(params[:userid])])
    pic = Paint.find_by(title: URI.unescape(params[:title]), userid: URI.unescape(params[:userid]))
   # pic = @pic.take
    send_file("public/img/#{pic.title}.png", :disposition => 'inline')
  end

  def img_show
    @img = Paint.where(userid: params[:userid])
    #send_file("public/img/{img.title}.png", :disposition => 'inline')
  end

  def download
   # @pic = Paint.new
    if @pic = Paint.find(params[:id])
     # send_data("img/{pic.filedata}.png", :type => 'image/png', :disposition => 'inline')
    end
  end
  
  def create
    #params[:paint][:aaa]
    @pic = Paint.new
    @pic.userid = params[:userid]
    @pic.title = "#{params[:title]}_#{params[:userid]}_" + Time.now.strftime("%y%m%H%M%S")
    file = Base64.decode64(params[:filedata])
    File.open("public/img/#{@pic.title}.png", 'wb') { |f|
      f.write(file)
    }
    file_path = URI.escape(params[:userid]) + '/' + URI.escape(@pic.title) + '.png'
    @pic.filedata = "http://paint.fablabhakodate.org/show/" + file_path
    @pic.category = params[:category]
    @pic.save
    redirect_to action: "index"
  end
  
  def convert
   # @pic = Paint.new
   # @pic = Paint.find(params[:id])
    _filepath = "public/img/#{params[:title]}.png"
    image = Magick::Image.read(_filepath)[0]
    image.format = "svg"
    _png = image.to_blob.to_s
    _png = _png.split(" cy=\""+(image.rows - 1).to_s , 2)
    _png.delete_at(-1)
    _str = _png.join
    14.times{|f|
      _str.chop!
    }
    _str = _str + "</svg>"
    _svg = Magick::Image.from_blob(_str)[0]
    _svg.format = "pdf"
    _pdf = _svg.to_blob
    send_data(_pdf, :type => "message/pdf", :filename => "convert.pdf", :disposition => 'attachment')
  end

  def to_blob
    @file = File.open("/img/#{params[:title]}.png").read
  end

  def forgot_passwd
    #params[:question]
    gogo_tea = nil
    if gogo_tea
      @user = Login.new
      if @user = Login.find_by_userid(params[:userid]) != nil
        @user.password = params[:password]
        @user.save
        #redirect_to action: "index"
      end
    end
    redirect_to action: "index"
  end

  def auth_user
    if cookies[:_ryokutya_session].present?
      if session[:session_id] == cookies[:_ryokutya_session]
        if user = Login.find(kie: session[:session_id])
       #   self.current_user = user
        else
       #   self.current_user = nil
        end
      end
    end
  end
  
  def current_user
    if session[:session_id]
      @current_user ||= Login.find_by_kie(cookies[:_ryokutya_session])
    end
  end
  
  def current_user=(user)
    @current_user = user
  end

  def logged_in?
    current_user != nil
  end

  def login_user
    user = Login.new
    #cookies.delete :_ryokutya_session
    #session[:session_id] = cookies[:_ryokutya_session]
    if params[:userid] !=nil && params[:password] != nil
      if user = Login.authenticate(params[:userid], params[:password])
        #if cookies[:_ryokutya_session] != user.kie
        if same_kie = Login.where(kie: cookies[:_ryokutya_session])
          #Login.update_all(['kie = ?', nil], ['kie = ?', cookies[:_ryokutya_session]])
          same_kie.update_all(kie: nil)
        end
        Login.update(user.id, :kie => cookies[:_ryokutya_session])
        # @user.kie = session[:data]
        # @user.save
        session[:session_id] = cookies[:_ryokutya_session]
        self.current_user = user
      end
    end
    redirect_to action: "index"
  end
  
  def logout_user
    session[:session_id] = nil
    cookies.delete :_ryokutya_session
    redirect_to action: "index"
  end

  def add_user
    if Login.find_by_userid(params[:userid]) == nil && params[:userid] != nil && params[:password] != nil
      session[:session_id] = cookies[:_ryokutya_session]
      @user = Login.new
      @user.userid = params[:userid]
      @user.password = params[:password]
      @user.kie = session[:session_id]
      @user.save
redirect_to action: "index"
    end 
  end
  
  def icon
    pic = Paint.find(params[:id])
 #   @pic.find(params[:id])
    send_data(Base64.decode64(pic.filedata), :disposition => 'inline')
  end

  private
  def user_params
    params.require(:paint).permit(:title, :userid, :filedata, :category)
    param.require(:login).permit(:userid, :password_hash, :password_salt, :kie)
  end
end
