class CreateTracks < ActiveRecord::Migration
  def change
    create_table :tracks do |t|
      t.string :file_name
      t.int :play_count
      t.int :skip_count
      t.string :name
      t.string :artist
      t.string :album

      t.timestamps
    end
  end
end
