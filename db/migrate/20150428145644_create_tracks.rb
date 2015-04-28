class CreateTracks < ActiveRecord::Migration
  def change
    create_table :tracks do |t|
      t.string :file_name
      t.integer :play_count
      t.integer :skip_count
      t.string :name
      t.string :artist
      t.string :album

      t.timestamps
    end
  end
end
