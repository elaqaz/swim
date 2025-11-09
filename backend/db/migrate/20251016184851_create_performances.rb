class CreatePerformances < ActiveRecord::Migration[8.0]
  def change
    create_table :performances do |t|
      t.references :swimmer, null: false, foreign_key: true
      t.string :stroke, null: false
      t.integer :distance_m, null: false
      t.string :course_type, null: false
      t.decimal :time_seconds, precision: 8, scale: 2, null: false
      t.string :original_time_str
      t.date :date, null: false
      t.string :meet_name
      t.integer :license_level
      t.string :license_no
      t.string :venue
      t.integer :wa_points
      t.string :source_url

      t.timestamps
    end
    add_index :performances, [ :swimmer_id, :stroke, :distance_m ]
  end
end
