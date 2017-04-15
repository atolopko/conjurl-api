# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20170415123056) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "short_url_requests", force: :cascade do |t|
    t.integer  "short_url_id", null: false
    t.datetime "requested_at", null: false
    t.inet     "ip_address",   null: false
    t.text     "referrer"
  end

  create_table "short_urls", force: :cascade do |t|
    t.datetime "created_at", default: -> { "now()" }, null: false
    t.text     "key",                                 null: false
    t.text     "target_url",                          null: false
    t.index ["key"], name: "short_urls_key_key", unique: true, using: :btree
  end

  add_foreign_key "short_url_requests", "short_urls", name: "short_url_requests_short_url_id_fkey"
end
