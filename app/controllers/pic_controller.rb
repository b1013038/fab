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
    @pic = Paint.new
    @pic.userid = params[:paint][:userid]
    @pic.title = params[:paint][:title]
    file = Base64.decode64(params[:paint][:filedata])
    @name = @pic.title + "_" + @pic.userid + "_" + Time.now.strftime("%y%m%H%M%S")
    File.open("public/img/#{@name}.png", 'wb') { |f|
      f.write(file)
    }
    @pic.filedata = "http://paint.fablabhakodate.org/pic/#{params[:paint][:userid]}/#{params[:paint][:title]}"
    @pic.category = params[:paint][:category]
    @pic.save
  end
  
  def convert
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
 
  def img_user
  end

  def img_show
    @pic = Paint.new
    if @pic = Paint.where(userid: params[:userid]) == nil
      redirect_to '/pic/index'
    end
    #    @pic = Pic.where(userid: params[:userid])
    if @pic.find(params[:id]) == nil
      redirect_to '/pic/index'
    end
    
    send_data(Base64.decode64(@pic.filedata), :type => 'image/png', filename: params[:title])
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
    param.require(:login).permit(:userid, :mysign)
  end
end
