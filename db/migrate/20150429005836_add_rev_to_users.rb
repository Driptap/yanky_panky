class AddRevToUsers < ActiveRecord::Migration
  def change
  	add_column :users, :track_rev, :string
  end
end
