class CreatePdfIngestJobs < ActiveRecord::Migration[8.0]
  def change
    create_table :pdf_ingest_jobs do |t|
      t.string :url
      t.string :file_hash
      t.string :status
      t.jsonb :parsed_json
      t.decimal :confidence, precision: 4, scale: 3

      t.timestamps
    end
  end
end
