class AddCourseSpecificTimesToPerformances < ActiveRecord::Migration[8.0]
  def change
    add_column :performances, :lc_time_seconds, :float
    add_column :performances, :sc_time_seconds, :float
  end
end
