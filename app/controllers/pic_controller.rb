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
    end
    respond_to do |format|
      format.any {render json: blob.to_json}
    end
  end
  
  def show
    #if pic = Paint.find(params[:id])
    #  pic = Paint.find_by(title: URI.unescape(params[:title]), userid: URI.unescape(params[:userid]))
    #end
    if params[:category]
      @img = Paint.where(category: params[:category])
    #else
      #if self.logged_in?
        @img = Paint.where(userid: self.current_user.userid) if params[:category];
     # else
     #   @img = Paint.where(category: 1)
     # end
    end
    respond_to do |format|
     # if params[:id].nil?
     #   format.png {send_file("public/img/#{pic.title}.png", :disposition => 'inline')}
        format.json
     # else
     #   format.png {redirect_to action: 'index', notice: "missing id!"}
     # end
    end
  end
  
  def img_show
    if params[:category]
      @img = Paint.where(category: params[:category])
    else
      if self.logged_in?
        @img = Paint.where(userid: self.current_user.userid)
      else
        @img = Paint.where(category: 1)
      end
    end
    respond_to do |format|
      format.html
      format.json
    end
  end
  
  def download
    # @pic = Paint.new
    if @pic = Paint.find(params[:id])
      # send_data("public/img/#{pic.title}.png", :type => 'image/png', :disposition => 'inline')
    end
  end
  
  def create
    #    if Login.find_by_kie(request.session_options[:id])
    pic = Paint.new
    pic.userid = params[:userid]
    pic.title = "#{params[:title]}_#{params[:userid]}_" + Time.now.strftime("%y%m%H%M%S")
    file = Base64.decode64(params[:filedata])
    File.open("public/img/#{pic.title}.png", 'wb') { |f|
      f.write(file)
    }
    #file_path = URI.escape(params[:userid]) + '/' + URI.escape(pic.title) + '.png'
    pic.filedata = "http://paint.fablabhakodate.org/img/#{pic.title}.png"
    pic.category = params[:category]
    #    end
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
    send_data(_pdf, :type => "message/pdf", :filename => "convert#{params[:title]}.pdf", :disposition => 'attachment')
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
  
  def current_user
    if session[:session_id]
      #      @current_user ||= Login.find_by_kie(cookies[:_ryokutya_session])
      @current_user ||= Login.find_by_kie(request.session_options[:id])
    end
  end
  
  def current_user=(user)
    @current_user = user
  end
  
  def logged_in?
    current_user != nil
  end
  
  def login_user
    #if request.session_options[:id].nil?
    #  self.create_session_for_active_record
    #end
    #self.create_session_for_active_record
    user = Login.new
    #self.reset_and_create_session_for_active_record
    if params[:userid] && params[:password]
      # self.reset_and_create_session_for_active_record
      if user = Login.authenticate(params[:userid], params[:password])
        #        if same_kie = Login.where(kie: cookies[:_ryokutya_session])
        if same_kie = Login.where(kie: request.session_options[:id])
          same_kie.update_all(kie: "a")
        end
        Login.update(user.id, kie: request.session_options[:id])
        #        session[:session_id] = cookies[:_ryokutya_session]
        session[:session_id] = request.session_options[:id]
        self.current_user = user
      end
    end
    #    redirect_to action: "index"
    respond_to do |format|
      if self.logged_in?
        format.html {redirect_to index_url, notice: 'ログイン成功！'}
        format.json {render json: "success"}
      else
        format.html {redirect_to index_url, notice: 'ログイン失敗！'}
        format.json {render json: "error!!!!!!"}
      end
    end
  end
  
  def logout_user
    usr = Login.where(kie: session[:session_id])
    usr.update_all(kie: "a")
    request.env[ActiveRecord::SessionStore::Session.primary_key] = nil         
    reset_session
    request.session_options[:id] = SecureRandom.hex(16)
    #usr.kie = "a"
    #usr.save
    session[:session_id] = nil
    cookies.delete :_ryokutya_session
    #self.current_user = nil
    #redirect_to action: "index"
    #self.reset_and_create_session_for_active_record
    respond_to do |format|
      if cookies[:_ryokutya_session].nil?
        format.html {redirect_to index_url, notice: 'ログアウトしました！'}
        format.json {render json: "success"}
      else
        format.html {redirect_to index_url, notice: 'ログアウトできてない'}
        format.json {render json: "error!!!!!!"}
      end
    end
  end
  
  def add_user
    session[:session_id] = request.session_options[:id]
    user = Login.new
    user.userid = params[:userid]
    if params[:password].length > 3 && params[:password].length < 11
      user.password = params[:password]
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
  
 # def reset_and_create_session_for_active_record
    #request.env[ActiveRecord::SessionStore::Session.primary_key] = nil
    #request.env[ActiveRecord::SessionStore::SESSION_RECORD_KEY] = nil
    #reset_session
    #request.session_options[:id] = SecureRandom.hex(16)
 # end
  
 # def create_session_for_active_record
    #  request.env[ActiveRecord::SessionStore::SESSION_RECORD_KEY] = nil
    #request.env[ActiveRecord::SessionStore::SESSION_RECORD_KEY] = nil
    #reset_session
    #ActiveRecord::SessionStore::Session.primary_key
    #request.session_options[:id] = SecureRandom.hex(16)
 # end
  
  def icon
    pic = Paint.find(params[:id])
    send_data(Base64.decode64(pic.filedata), disposition: 'inline')
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
    
  end
  
  private
  def user_params
    params.require(:paint).permit(:title, :userid, :filedata, :category)
    param.require(:login).permit(:userid, :password_hash, :password_salt, :kie)
  end
end
