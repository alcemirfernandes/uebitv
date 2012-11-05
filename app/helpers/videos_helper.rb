module VideosHelper
  def error(video)
    html = ""
	  html << "<h2>#{pluralize(video.errors.count, 'erros')} impediram que este video fosse salvo:</h2>"
	  html << "<ul>"
      video.errors.full_messages.each do |msg| 
        html << "<li>#{msg}</li>"
      end 
	  html << "</ul>"
	    	
  	raw html
  end
end
