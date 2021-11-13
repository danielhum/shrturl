# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2021_11_12_062050) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "click_events", force: :cascade do |t|
    t.bigint "short_url_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.float "latitude"
    t.float "longitude"
    t.string "ip_address"
    t.index ["short_url_id"], name: "index_click_events_on_short_url_id"
  end

  create_table "short_urls", force: :cascade do |t|
    t.string "url_key"
    t.bigint "target_url_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["target_url_id"], name: "index_short_urls_on_target_url_id"
    t.index ["url_key"], name: "index_short_urls_on_url_key", unique: true
  end

  create_table "target_urls", force: :cascade do |t|
    t.string "url"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["url"], name: "index_target_urls_on_url"
  end

  add_foreign_key "click_events", "short_urls"
  add_foreign_key "short_urls", "target_urls"
end
