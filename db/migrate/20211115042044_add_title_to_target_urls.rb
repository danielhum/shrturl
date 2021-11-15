class AddTitleToTargetUrls < ActiveRecord::Migration[6.1]
  def change
    add_column :target_urls, :title, :string
  end
end
