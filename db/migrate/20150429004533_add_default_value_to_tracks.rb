class AddDefaultValueToTracks < ActiveRecord::Migration
  def change
	change_column :tracks, :play_count, :integer,  :default => 0
	change_column :tracks, :skip_count, :integer, :default => 0	
  end
end
