class AddAttachmentArchiveToVideos < ActiveRecord::Migration
  def self.up
    change_table :videos do |t|
      t.has_attached_file :archive
    end
  end

  def self.down
    drop_attached_file :videos, :archive
  end
end
