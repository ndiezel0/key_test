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

ActiveRecord::Schema.define(version: 20180822162805) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "categories", force: :cascade do |t|
    t.integer "cat_id"
    t.bigint "parent_id"
    t.string "name"
    t.bigint "company_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["company_id"], name: "index_categories_on_company_id"
    t.index ["parent_id"], name: "index_categories_on_parent_id"
  end

  create_table "companies", force: :cascade do |t|
    t.string "name"
    t.string "company_name"
    t.string "url"
    t.integer "local_delivery_cost"
    t.bigint "source_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["source_id"], name: "index_companies_on_source_id"
  end

  create_table "currencies", force: :cascade do |t|
    t.string "uid"
    t.string "rate"
    t.bigint "company_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["company_id"], name: "index_currencies_on_company_id"
  end

  create_table "extra_infos", force: :cascade do |t|
    t.bigint "offer_id"
    t.string "name"
    t.string "value"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["offer_id"], name: "index_extra_infos_on_offer_id"
  end

  create_table "offer_categories", force: :cascade do |t|
    t.bigint "offer_id"
    t.bigint "category_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["category_id"], name: "index_offer_categories_on_category_id"
    t.index ["offer_id"], name: "index_offer_categories_on_offer_id"
  end

  create_table "offers", force: :cascade do |t|
    t.bigint "company_id"
    t.bigint "off_id"
    t.bigint "group_id"
    t.boolean "available"
    t.string "ctype"
    t.string "url"
    t.integer "price"
    t.integer "base_price"
    t.bigint "currency_id"
    t.string "picture"
    t.string "age"
    t.string "barcode"
    t.string "name"
    t.string "type_prefix"
    t.string "vendor"
    t.string "model"
    t.string "description"
    t.string "sales_notes"
    t.boolean "store"
    t.boolean "pickup"
    t.boolean "delivery"
    t.string "ordering_time"
    t.string "manufacturer_warranty"
    t.integer "local_delivery_cost"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["company_id"], name: "index_offers_on_company_id"
    t.index ["currency_id"], name: "index_offers_on_currency_id"
  end

  create_table "sources", force: :cascade do |t|
    t.string "url"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

end
