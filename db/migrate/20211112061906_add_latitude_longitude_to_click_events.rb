class AddLatitudeLongitudeToClickEvents < ActiveRecord::Migration[6.1]
  def change
    add_column :click_events, :latitude, :float
    add_column :click_events, :longitude, :float
  end
end
