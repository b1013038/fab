# -*- coding: utf-8 -*-
class Admin::LoginsController < Admin::ResourcesController
  def danger
    str = ""
    Dir::glob("public/img/*.png").each do |png|
      _png = Paint.new
      png = png.split("/")[2].split(".")[0]
      _png.title =  png
      _png.userid = png.split("_")[1]
      _png.category = 1
      _png.filedata = "http://paint.fablabhakodate.org/img/#{png}.png"
      str = str + "title: #{_png.title}, userid: #{_png.userid}, category: #{_png.category}, filedata: #{_png.filedata}..."
    end    
    File.open("public/kakidasi", 'wb') { |f|
      f.write(str)
    }
  end

  def danger2
    str = ""
    _png = Paint.all
    _png.each do |png|
      png.title = "#{png.title.split("_")[0]}_#{png.title.split("_")[1]}_#{png.category.to_s}_#{png.title.split("_")[-1]}"
      png.filedata = "http://paint.fablabhakodate.org/img/#{png.title}.png"
      str = str + "filedata: #{png.filedata}|||"
    end
    File.open("public/kakidasi", 'wb') { |f|
      f.write(str)
    }
  end
  
end
