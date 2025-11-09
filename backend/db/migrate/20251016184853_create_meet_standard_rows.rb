class CreateMeetStandardRows < ActiveRecord::Migration[8.0]
  def change
    create_table :meet_standard_rows do |t|
      t.references :meet_standard_set, null: false, foreign_key: true
      t.string :gender
      t.integer :age_min
      t.integer :age_max
      t.string :stroke, null: false
      t.integer :distance_m, null: false
      t.string :pool_of_standard
      t.string :standard_type, null: false
      t.decimal :time_seconds, precision: 8, scale: 2, null: false

      t.timestamps
    end
  end
end
