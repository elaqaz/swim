class CreateMeetStandardSets < ActiveRecord::Migration[8.0]
  def change
    create_table :meet_standard_sets do |t|
      t.string :name, null: false
      t.string :season
      t.string :region
      t.string :promoter
      t.string :pool_required
      t.string :age_rule_type
      t.date :age_rule_date
      t.date :window_start
      t.date :window_end
      t.text :notes
      t.string :source_pdf_url

      t.timestamps
    end
  end
end
