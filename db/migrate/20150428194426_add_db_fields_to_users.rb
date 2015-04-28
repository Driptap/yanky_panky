class AddDbFieldsToUsers < ActiveRecord::Migration
  def change
  	add_column :users, :db_user_id, :string
  	remove_column :users, :name
  end
end
