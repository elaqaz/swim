class AddIdToUserSwimmers < ActiveRecord::Migration[8.0]
  def change
    # Add primary key column to user_swimmers table
    add_column :user_swimmers, :id, :primary_key
  end
end
