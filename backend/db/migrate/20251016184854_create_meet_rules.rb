class CreateMeetRules < ActiveRecord::Migration[8.0]
  def change
    create_table :meet_rules do |t|
      t.references :meet_standard_set, null: false, foreign_key: true
      t.integer :min_license_level
      t.boolean :allow_sc_to_lc, default: false
      t.boolean :allow_lc_to_sc, default: false
      t.text :include_levels_text

      t.timestamps
    end
  end
end
