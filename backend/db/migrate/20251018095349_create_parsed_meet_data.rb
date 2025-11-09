class CreateParsedMeetData < ActiveRecord::Migration[8.0]
  def change
    create_table :parsed_meet_data do |t|
      t.jsonb :data
      t.string :status
      t.text :error_message

      t.timestamps
    end
  end
end
