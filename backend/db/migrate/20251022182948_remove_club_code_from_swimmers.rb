class RemoveClubCodeFromSwimmers < ActiveRecord::Migration[8.0]
  def change
    remove_column :swimmers, :club_code, :string
  end
end
