module VideosHelper
  def error(video)
    html = ""
    html << "<div id='error_explanation' class='alert alert-error'>"		
    html << "<button data-dismiss='alert' class='close' type='button' onclick='close_notification()'>x</button>"
	  html << "<h2>#{pluralize(video.errors.count, 'erros')} impediram que este video fosse salvo:</h2>"
	  html << "<ul>"
      video.errors.full_messages.each do |msg| 
        html << "<li>#{msg}</li>"
      end 
	  html << "</ul>"
	  html << "</div>"
	    	
  	raw html
  end
end