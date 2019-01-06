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

ActiveRecord::Schema.define(version: 20170706200927) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "items", force: :cascade do |t|
    t.string "name", null: false
    t.string "category_small", null: false
    t.string "category_large", null: false
    t.integer "quantity", default: 1, null: false
    t.datetime "expiration_date"
    t.integer "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "warning_date"
    t.index ["category_large"], name: "index_items_on_category_large"
    t.index ["category_small"], name: "index_items_on_category_small"
    t.index ["expiration_date"], name: "index_items_on_expiration_date"
    t.index ["name"], name: "index_items_on_name"
    t.index ["user_id"], name: "index_items_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "amazon_user_id"
    t.index ["amazon_user_id"], name: "index_users_on_amazon_user_id", unique: true
  end

  add_foreign_key "items", "users"
end
