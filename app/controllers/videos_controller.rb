class VideosController < ApplicationController
  respond_to :js, :except => [:next, :in_live]
  before_filter :load_videos, :only => [:index, :create]

  def index    
    @video = Video.new
    
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @videos }
    end
  end

  def new
    @video = Video.new  
    
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @video }
    end
  end

  def create
    @video = Video.new(params[:video])

     respond_to do |format|
       if @video.save
         @videos = Video.all_order_position
         format.html { redirect_to videos_path }
       else
         format.html { render :action => "new" }
       end
     end
  end

  def change_position
    video = Video.find params[:id]
    video.order_positions(params[:position]) if video 
    @videos = Video.all_order_position
  end 
  
  def next
    live = Video.in_live
    next_video = Video.next
    
    # primeira chamada     
    next_video.update_attributes(:live => true) if live.blank?
    
    # verifica se o que esta na fila é diferente do proximo para atualizar campo.
    in_queue = Video.in_queue  
    in_queue.update_attribute(:queue, false) if in_queue && in_queue != next_video
    
    # proximas chamadas
    if live
      next_video.update_attribute(:queue, true)   
      live.update_attribute(:queue, false) 
    end
    
    render :text => "#{next_video.archive_file_name}"
  end
  
  def inlive
  
    # verifica se existe um video tocando
    current_video = Video.in_live        

    # atualiza o video que esta tocando para false    
    current_video.update_attributes(:live => false) if current_video
      
    # obtem proximo video
    next_video = Video.next        
    
    # atualiza proximo video como ao vivo
    next_video.update_attributes(:live => true) if next_video         
  

    render :text => "OK"
  end  
  
  def player
    render :layout => true
  end

protected
  def load_videos
    @videos = Video.all_order_position
  end
end
