class AddRawResponseToParsedMeetData < ActiveRecord::Migration[8.0]
  def change
    add_column :parsed_meet_data, :raw_response, :text
  end
end
