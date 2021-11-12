class CreateClickEvents < ActiveRecord::Migration[6.1]
  def change
    create_table :click_events do |t|
      t.references :short_url, null: false, foreign_key: true

      t.timestamps
    end
  end
end
