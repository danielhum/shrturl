class AddIpAddressToClickEvents < ActiveRecord::Migration[6.1]
  def change
    add_column :click_events, :ip_address, :string
  end
end
