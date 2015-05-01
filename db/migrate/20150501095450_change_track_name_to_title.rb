class ChangeTrackNameToTitle < ActiveRecord::Migration
  def change
  	rename_column :tracks, :name, :title
  end
end
