class Video < ActiveRecord::Base
  before_create :generate_id
  before_create :set_position
  before_create :rename_file
  
  validates_presence_of :title
  validates_attachment :archive, 
                       :presence => true, 
                       :content_type => { :content_type => ["video/mp4", "video/flv"] },
                       :size => { :in => 0..10000.kilobytes }
  
  has_attached_file :archive, 
                    :url => APP_CONFIG["video"]["url"],
                    :path => APP_CONFIG["video"]["path"] 
  
  scope :views_asc, order("views ASC")
  scope :position_asc, order("position ASC")
  scope :all_order_position, where("position > 0").position_asc
                        
  def generate_id
    seed = "--tom-#{rand(10000)}--#{Time.now}-tv--"                 
    self.id = Digest::SHA1.hexdigest(seed)[0,10]
  end  
  
  def rename_file
   extension = File.extname(archive_file_name).downcase
   seed = "--uebi-#{rand(10000)}--#{Time.now}-tv--"                    
   self.archive.instance_write :file_name, "#{Digest::SHA1.hexdigest(seed)[0,10]}#{extension}"
  end
  
  def self.next        
    _next = where("queue = true AND live = false").first
    
    if !_next
      _current = where("live = true").first
      if _current
        _next = where("position = ?", (_current.position + 1)).first            

        unless _next
          _next = Video.all_order_position.first
        end
      else
        _next = Video.all_order_position.first
      end
    end
    
    _next
  end
  
  def self.in_live
    where("live = true").views_asc.position_asc.first
  end
  
  def self.in_queue
    where("queue = true").views_asc.position_asc.first
  end
  
  def set_position
    self.position = last_position
  end
  
  def last_position
    videos = Video.all_order_position
    videos.blank? ? 1 : videos.size + 1
  end
  
  def set_valid_position(new_position) 
    new_position = new_position.to_i   
    next_position = last_position  
    
    if new_position.to_i > 0 && new_position > next_position
      next_position
    else
      position
    end
  end  
  
  def order_positions(new_position, type=nil)    
    up = false
    if !new_position.blank? && new_position.to_i > position
      conditions = "id != ? AND position BETWEEN ? AND ? ", id, position, new_position.to_i
      order = "position DESC"
    elsif !new_position.blank? && new_position.to_i < position && new_position.to_i > 0
      conditions = "id != ? AND position BETWEEN ? AND ? ", id, new_position.to_i, position
      order = "position ASC"      
      up = true
    elsif !new_position.blank? && new_position.to_i == position  
      conditions = "id != ? AND position = ? ", id, new_position.to_i      
      order = "position DESC"      
      up = true
    end
    
    unless conditions.blank?
      Video.order(order).where(conditions).each do |video|
        if up 
          video.increment!(:position) 
        else
          video.decrement!(:position) 
        end
      end          
      
      self.update_attribute(:position, new_position)
    end
    
#    order_positions_when_delete(type) unless type.nil?
  end
end
