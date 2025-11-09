class AddPdfFieldsToParsedMeetData < ActiveRecord::Migration[8.0]
  def change
    add_column :parsed_meet_data, :pdf_filename, :string
    add_column :parsed_meet_data, :pdf_content_type, :string
    add_column :parsed_meet_data, :pdf_data, :binary
  end
end
