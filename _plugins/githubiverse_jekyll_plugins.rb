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


  class ImagesTag < Liquid::Tag

    def initialize(tag_name, text, tokens)
      super
    end
          
            
    def render(context)
      img_html = "<ul class='thumbnails'>"

      site = context.registers[:site]

      site.static_files.each do |file|

        if (file.path.include? site.config['githubiverse']['img_dir']) 
          if (['.png','.jpg'].include? File.extname(file.path).downcase) 

            url = site.config['githubiverse']['img_dir'] + File.basename(file.path)
            img_html << "<li class='span2'><a class='thumbnail' href='#{url}' rel='lightbox[mm27]'><img class='imgfile' src='#{url}' alt='"+File.basename(file.path)+"' /></a></li>"

          end
        end
      end

      img_html << "</ul>"

      return img_html
    end
  end

end

Liquid::Template.register_filter(Jekyll::GithubiverseFilters)
Liquid::Template.register_tag('images', Jekyll::ImagesTag)