require 'RMagick'
require 'nokogiri'
include Magick

module Jekyll

  module GithubiverseFilters
    
    def stls(content)
      
      stl_list = "<ul>"
      
      @context.registers[:site].static_files.each do |file|
        if  (File.extname(file.path).downcase == '.stl')
            stl_list += "<li><a href=\"javascript://\" class=\"stlfile\">"+File.basename(file.path)+"</a></li>"
        end
      end
      
      stl_list += "</ul>"

      return stl_list
    end

    def srcs(content)
      site = @context.registers[:site]

      src_list = "<ul>"
      
      site.static_files.each do |file|
        if  (file.path.include? '/shared/src/')
            src_list += "<li><a href=\"#{File.dirname(file.path).sub(site.source, '')<<'/'<<File.basename(file.path)}\" class=\"srcfile\">#{File.basename(file.path)}</a></li>"
        end
      end
      
      src_list += "</ul>"
      
      return src_list
    end

    def imageextract(content)
      
      img_list = "<ul>"
      
      @context.registers[:site].static_files.each do |file|
        if  (file.path.include? '/shared/img/')
            img_list += "<li><img src=\"/shared/img/"+File.basename(file.path)+"\" class=\"imgfile\" alt=\""+File.basename(file.path)+ "\" /></li>"
        end
      end

      img_list += "</ul>"

      return img_list
    end
  end

  #
  # Modified from https://github.com/matthewowen/jekyll-slideshow
  #
  class ThumbGenerator < Generator
    safe true
    
    def generate(site)

      unless site.config['githubiverse']['generate_thumbs'].nil?
        if !site.config['githubiverse']['generate_thumbs']
          return
        end
      else
        return
      end

      # go through all the images in the site, generate thumbnails for each one

      # if we don't have values set for thumbnails, use a sensible default
      if Jekyll.configuration({}).has_key?('slideshow')
        config = Jekyll.configuration({})['slideshow']
      else 
        config = Hash["width", 100, "height", 100]
      end
      
      to_thumb = Array.new
      thumbs_dir = site.config['githubiverse']['thumb_dir']

      # create a list of images to be thumbed
      # avoids problem with running over and over the old thumb
      site.static_files.each do |file|

        if (file.path.include? site.config['githubiverse']['img_dir']) 
          if ((['.png','.jpg'].include? File.extname(file.path).downcase) && (!File.basename(file.path).include? "-thumb"))

              to_thumb.push(file)

          end
        end
      end

      to_thumb.each do |file|

          img = Magick::Image::read(file.path).first

          thumb = img.resize_to_fit(config['width'], config['height'])

          path = thumbs_dir + File.basename(file.path).sub(File.extname(file.path), '-thumb' << File.extname(file.path))

          thumb.write path

          site.static_files << StaticFile.new(thumb, 
                                              site.source,
                                              thumbs_dir,
                                              File.basename(file.path).sub(File.extname(file.path), '-thumb' << File.extname(file.path)))
      end
    end
  end

  #
  # Modified from https://github.com/matthewowen/jekyll-slideshow
  #
  module ImageThumbs
    def slideshows(content)

      print "content ",content," \n"
      # go through content using the slideshows filter
      # for any imgs in <ul>s, change the src to use the new thumbs
      # set a data attribute referencing the original (fullsize) image
      doc = Nokogiri::HTML.fragment(content)
      doc.css('ul li img').each do |img|
        url = img['src']
        newurl = File.dirname(url) << '/' << File.basename(url,File.extname(url)) << '-thumb' << File.extname(url)

        img['src'] = newurl
        img['data-fullimage'] = url
      end
      return doc.to_html
    end
  end


  class ImagesTag < Liquid::Tag

    def initialize(tag_name, text, tokens)
      super
    end

    def render(context)
      img_html = ""

      site = context.registers[:site]

      site.static_files.each do |file|

        if (file.path.include? site.config['githubiverse']['img_dir']) 
          if ((['.png','.jpg'].include? File.extname(file.path).downcase) && (!File.basename(file.path).include? "-thumb"))

            url = site.config['githubiverse']['img_dir'] + File.basename(file.path)
            newurl = site.config['githubiverse']['thumb_dir'] +  File.basename(url,File.extname(url)) << '-thumb' << File.extname(url)

            img_html << "<img class='imgfile' src='"+newurl+"' data-fullimage='"+url+"' alt='"+File.basename(file.path)+"' />"

          end
        end
      end

      return img_html
    end
  end

end

Liquid::Template.register_filter(Jekyll::GithubiverseFilters)
#Liquid::Template.register_filter(Jekyll::ImageThumbs)
Liquid::Template.register_tag('images', Jekyll::ImagesTag)