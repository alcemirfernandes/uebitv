class VideosController < ApplicationController
  respond_to :js, :except => [:next, :in_live]
  
  # GET /videos
  # GET /videos.xml
  def index
    @videos = Video.all_order_position
    @video = Video.new
    
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @videos }
    end
  end


  # GET /videos/new
  # GET /videos/new.xml
  def new
    @video = Video.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @video }
    end
  end

  # GET /videos/1/edit
  def edit
    @video = Video.find(params[:id])
  end

  # POST /videos
  # POST /videos.xml
  def create
    @video = Video.new(params[:video])

     respond_to do |format|
       if @video.save
         @videos = Video.all             	
         format.html { redirect_to videos_path }
       else
         format.js
       end
     end
  end

  # PUT /videos/1
  # PUT /videos/1.xml
  def update
    @video = Video.find(params[:id])

    respond_to do |format|
      if @video.update_attributes(params[:video])
        format.html { redirect_to(@video, :notice => 'Video was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @video.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /videos/1
  # DELETE /videos/1.xml
  def destroy
    @video = Video.find(params[:id])
    @video.destroy

    respond_to do |format|
      format.html { redirect_to(videos_url) }
      format.xml  { head :ok }
    end
  end
  
  def change_position
    video = Video.find params[:id]
    video.order_positions(params[:position]) if video    
  end
  
  
  def next
    live = Video.in_live
    next_video = Video.next
        
    next_video.update_attribute(:live, true) if live.blank?
    next_video.update_attribute(:queue, true) if live
    
    render :text => "#{next_video.title} [#{next_video.archive_file_name}]"
  end
  
  def in_live
    # obtem proximo video
    current_video = Video.next        

    # atualiza proximo video como ao vivo
    current_video.update_attributes(:live => true, :queue => false) if current_video
    
    # obtem proximo video 
    next_video = Video.next

    # adiciona proximo video na fila
    next_video.update_attribute(:queue, true) if next_video    
    
    
    # verifica se existe um video tocando
    live = Video.in_live        
    
    # atualiza o video que esta tocando para false    
    live.update_attributes(:live => false) if live

    render :text => "#{next_video.title} [#{next_video.archive_file_name}]"
  end
end
