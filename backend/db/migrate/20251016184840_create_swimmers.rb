class CreateSwimmers < ActiveRecord::Migration[8.0]
  def change
    create_table :swimmers do |t|
      t.string :se_membership_id
      t.string :first_name, null: false
      t.string :last_name, null: false
      t.date :dob, null: false
      t.string :sex, limit: 1, null: false
      t.string :club
      t.string :club_code

      t.timestamps
    end
    add_index :swimmers, :se_membership_id, unique: true
  end
end
