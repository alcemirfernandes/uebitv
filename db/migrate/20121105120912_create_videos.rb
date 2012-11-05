class CreateVideos < ActiveRecord::Migration
  def self.up
    create_table :videos, :id => false do |t|
      t.string :id
      t.string :title
      t.integer :position
      t.boolean :queue, :default => false
      t.boolean :live, :default => false
            
      t.timestamps
    end
    
    execute "ALTER TABLE videos ADD PRIMARY KEY (id);"
  end

  def self.down
    drop_table :videos
  end
end
