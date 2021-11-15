class AddCityStateCountryToClickEvents < ActiveRecord::Migration[6.1]
  def change
    add_column :click_events, :city, :string
    add_column :click_events, :state, :string
    add_column :click_events, :country, :string
  end
end
