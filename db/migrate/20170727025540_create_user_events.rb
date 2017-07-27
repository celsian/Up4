class CreateUserEvents < ActiveRecord::Migration[5.1]
  def change
    create_table :user_events do |t|
      t.references :user, index: true
      t.references :event, index: true

      t.timestamps
    end
  end
end
