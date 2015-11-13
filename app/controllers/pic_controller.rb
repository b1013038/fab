# coding: utf-8

class PicController < ApplicationController
  def index
    @pic = Paint.new
  end

  def show
    # @pic = find(params[:userid])
    #send_data(Base64.decode64(Paint.find(:id).filedata), :type => 'image/png', :disposition => 'inline')
    @pic = Paint.new
    @pic = Paint.where(userid: params[:paint][:userid])
  end

  def download
    
    #    require 'RMagick'
    #    file = open(/assets/images/remonn.rb)
    #    base64_text = file.read
    #    print base64_text
    # binary_data = base64_data.unpack('m')[0]
    #imagelist = RMagick::ImageList.new
    #imagelist.from_blob(binary_data)
    #    file.close
    
  end
  
  def create
    #params[:paint][:aaa]
    @pic = Paint.new
    @pic.userid = params[:userid]
    @pic.title = params[:title]
    file = Base64.decode64(params[:filedata])
    @name = @pic.title + "_" + @pic.userid + "_" + Time.now.strftime("%y%m%H%M%S")
    File.open("public/img/#{@name}.png", 'wb') { |f|
      f.write(file)
    }
    @pic.filedata = "http://paint.fablabhakodate.org/#{params[:userid]}/#{params[:title]}"
    @pic.category = params[:category]
    @pic.save
    redirect_to root_path
  end
  
  def convert
    #filepath = "public/img" + Paint.find(params[:id])
    @filename = Paint.select("filedata")
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
  end

  def login_user
    if user = Login.authenticate(params[:userid], params[:password])
      if cookies[:_ryokutya_session] != user.kie
        Login.update(user.id, :kie => cookies[:_ryokutya_session])
      end
    end
    redirect_to :action => "index"
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

  def show_pic

  end
  
  def icon
    @pic = Pic.all
#    @pic = Pic.where(userid: params[:userid])
    @pic.find(params[:id])
    send_data(Base64.decode64(@pic.filedata), :disposition => 'inline')
  end

  private
  def user_params
    params.require(:paint).permit(:title, :userid, :filedata, :category)
    param.require(:login).permit(:userid, :password_hash, :password_salt)
  end
end
