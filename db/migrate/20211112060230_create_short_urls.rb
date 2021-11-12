class CreateShortUrls < ActiveRecord::Migration[6.1]
  def change
    create_table :short_urls do |t|
      t.string :url_key
      t.references :target_url, null: false, foreign_key: true

      t.timestamps
    end
    add_index :short_urls, :url_key
  end
end
