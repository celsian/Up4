class CreateEvents < ActiveRecord::Migration[5.1]
  def change
    create_table :events do |t|
      t.string :name
      t.string :description
      t.string :time_date
      t.string :location
      t.references :user, index: true

      t.timestamps
    end
  end
end
