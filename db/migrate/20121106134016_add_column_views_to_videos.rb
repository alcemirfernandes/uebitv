class AddColumnViewsToVideos < ActiveRecord::Migration
  def self.up
    add_column :videos, :views, :integer, :default => 0
  end

  def self.down
    remove_column :videos, :views
  end
end
