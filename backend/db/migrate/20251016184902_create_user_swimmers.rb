class CreateUserSwimmers < ActiveRecord::Migration[8.0]
  def change
    create_table :user_swimmers, id: false do |t|
      t.references :user, null: false, foreign_key: true
      t.references :swimmer, null: false, foreign_key: true
      t.string :nickname
      t.integer :display_order

      t.timestamps
    end
    add_index :user_swimmers, [ :user_id, :swimmer_id ], unique: true
  end
end
