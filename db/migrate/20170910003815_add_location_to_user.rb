class AddLocationToUser < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :location, :string
    add_column :users, :latitude, :float
    add_column :users, :longitude, :float
    add_column :users, :search_radius, :integer
  end
end