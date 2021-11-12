class CreateTargetUrls < ActiveRecord::Migration[6.1]
  def change
    create_table :target_urls do |t|
      t.string :url

      t.timestamps
    end
    add_index :target_urls, :url
  end
end
