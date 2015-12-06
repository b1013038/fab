# -*- coding: utf-8 -*-
# coding: utf-8

class PicController < ApplicationController
  helper_method :current_user, :logged_in? 
  protect_from_forgery except: :pic_action
  
 
  def index
    @pic = Paint.new
    @img = Paint.last(10)
    @test = request.session_options[:id]
    @id = session[:session_id]
  end
  
  def to_blob
    pic = nil
    if pic = Paint.find(params[:id])
      blob = {filedata: Base64.encode64(File.open("public/img/#{pic.title}.png").read).chomp}
    else
      blob = "id can't be nil."
    end
    render json: blob
  end
  
  def show
    if params[:category]
      if params[:category] == "-1"
        @img = Paint.where(userid: Login.find_by_kie(request.session_options[:id]).userid)
      else
        @img = Paint.where(category: params[:category])
      end
    end
    render "show", formats: [:json], handlers: [:jbuilder]
#    render json:
  end
  
  def img_show
    if params[:category]
      if self.logged_in? && params[:category] == "-1"
        @img = Paint.where(userid: self.current_user.userid)
      else
        @img = Paint.where(category: params[:category])
      end
    end
    respond_to do |format|
      format.html
      format.json
    end
  end
  
  def download
    if @pic = Paint.find(params[:id])
      # send_data("public/img/#{pic.title}.png", :type => 'image/png', :disposition => 'inline')
    end
  end
  
  def create
    #    if Login.find_by_kie(request.session_options[:id])
    pic = Paint.new
    pic.userid = params[:userid]
    pic.title = "#{params[:title]}_#{params[:userid]}_#{params[:category]}_" + Time.now.strftime("%y%m%H%M%S")
    file = Base64.decode64(params[:filedata])
    File.open("public/img/#{pic.title}.png", 'wb') { |f|
      f.write(file)
    }
    #file_path = URI.escape(params[:userid]) + '/' + URI.escape(pic.title) + '.png'
    pic.filedata = "http://paint.fablabhakodate.org/img/#{pic.title}.png"
    pic.category = params[:category]
    #    end
    pic.save
    unless pic.save
      @pic_error_message = [pic.errors.full_messages].compact
    end
#    respond_to do |format|
#      if pic.save
#        format.html {redirect_to index_url, notice: '成功！'}
#        format.json {render json: pic}
#      else
#        format.html {redirect_to index_url, motice: '失敗'}
#        format.json {render json: pic.errors.full_messages, status: :unprocessable_entity }
#      end
#    end
  end

  def convert_potrace
    _filepath = "public/img/#{params[:title]}.png"
    image = Magick::Image.read(_filepath)[0]
    scale = params[:size].split("x")
    image = image.resize(scale[0].to_i,scale[1].to_i)
    image.format = "bmp"
    image.write("public/img/#{params[:title]}.bmp")
    #File.open("public/img/#{params[:title]}.bmp", 'wb') { |f|
    #  f.write()
    #}
    result = `potrace -s -o public/img/#{params[:title]}.bmp public/img/#{params[:title]}.svg`
    #_svg = Magick::Image.read("public/img/#{pic.title}.svg")[0]
    send_data("public/img/#{pic.title}.svg", :filename => "aaa_convert#{params[:title]}.svg", :disposition => 'attachment')
  end
  
  def convert
    _filepath = "public/img/#{params[:title]}.png"
    image = Magick::Image.read(_filepath)[0]
    #image = image.resize(params[:width], params[:height])
    scale = params[:size].split("x")
    image = image.resize(scale[0].to_i,scale[1].to_i) 
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
    #send_data(_pdf, :filename => "convert#{params[:title]}.svg", :disposition => 'attachment')
    send_data(_pdf, :type => "message/pdf", :filename => "convert_#{params[:title].split("_")[0]}.pdf", :disposition => 'attachment')
  end
  
  def forgot_passwd
    #params[:question]
    gogo_tea = nil
    if gogo_tea
      @user = Login.new
      if @user = Login.find_by_userid(params[:userid]) != nil
        @user.password = params[:password]
        @user.save
      end
    end
    redirect_to action: "index"
  end
   
  def signin_user
    if user = Login.authenticate(params[:userid], params[:password])
      if same_kie = Login.where(kie: request.env['HTTP_COOKIE'].split('=')[1])
        same_kie.update_all(kie: "logout")
      end
      Login.update(user.id, kie: request.env['HTTP_COOKIE'].split('=')[1])
      session[:session_id] = request.env['HTTP_COOKIE'].split('=')[1]
      ssmsg = {'userid' => "#{params[:userid]}"}
      self.current_user = user
      #msg = {'id' => user.userid}
    else
      error_message = {'error' => 'login_error'}
    end
    if self.current_user.nil?
      #render "signinuser", :formats => [:json], :handlers => [:jbuilder]
      #render json: error_message
      #render json: msg
      #end
      render json: error_message
    else
      #render json: error_message
      render json: ssmsg
    end
  end
  
  def login_user
    user = Login.new
    if user = Login.authenticate(params[:userid], params[:password])
      if same_kie = Login.where(kie: request.session_options[:id])
        same_kie.update_all(kie: "logout")
      end
      Login.update(user.id, kie: request.session_options[:id])
      session[:session_id] = request.session_options[:id]
     self.current_user = user
    end
    respond_to do |format|
      if self.logged_in?
        format.html {redirect_to index_url, notice: 'ログイン成功！'}
      else
        format.html {redirect_to index_url, notice: 'ログイン失敗！'}
      end
    end
  end
  
  def logout_user
    usr = Login.where(kie: session[:session_id])
    if request.env['HTTP_COOKIE'].split('=')[1]
      usr = Login.where(kie: request.env['HTTP_COOKIE'].split('=')[1])
    end
    #usr = Login.where(kie: session[:session_id])
    usr.update_all(kie: "logout")
    #request.env[ActiveRecord::SessionStore::Session.primary_key] = nil         
    #reset_session
    #request.session_options[:id] = SecureRandom.hex(16)
    #usr.kie = "a"
    #usr.save
    #session[:session_id] = nil
    #cookies.delete :_ryokutya_session
    #self.current_user = nil
    #redirect_to action: "index"
    #self.reset_and_create_session_for_active_record
    respond_to do |format|
      if usr = Login.where(kie: session[:session_id])
        format.html {redirect_to root_url, notice: 'ログアウトしました！'}
        format.json {render json: "success"}
      else
        format.html {redirect_to root_url, notice: 'ログアウトできてない'}
        format.json {render json: "error!!!!!!"}
      end
    end
  end
  
  def add_user
    session[:session_id] = request.session_options[:id]
    user = Login.new
    user.userid = params[:userid] if params[:userid].ascii_only?
    if params[:password].length > 3 && params[:password].length < 11
      user.password = params[:password] if params[:password].ascii_only?
    end
    user.password_confirmation = params[:password_confirmation]
    #      user.kie = request.session_options[:id]
    user.kie = session[:session_id]
    user.save
    self.current_user = user
    respond_to do |format|
      if user.save
        format.html {redirect_to index_url, notice: "add ok"}
        format.json {render json: "success"}
      else
        format.html {redirect_to index_url, notice: "add no"}
        format.json {render json: "error!!!!!!"}
      end
    end 
  end
  
  def error_msg=(msg)
    respond_to do |format|
      format.html {redirect_to index_url}
      if msg
        format.json {render json: msg}
      else
        format.json {render json: "error!!!!!!"}
      end
    end
  end
  
  def nothing
    session[:session_id] = SecureRandom.hex(16)
    cookies[:_ryokutya_session] = {value: session[:session_id], httponly: true, path: "/signinuser"}
    respond_to do |format|
      #format.html
      format.json {render json: "nothing"}
    end
  end
  
  private
  def user_params
    params.require(:paint).permit(:title, :userid, :filedata, :category)
    param.require(:login).permit(:userid, :password_hash, :password_salt, :kie)
  end
end
