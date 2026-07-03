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

ActiveRecord::Schema[8.0].define(version: 2026_06_16_003608) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "accounts", force: :cascade do |t|
    t.string "code"
    t.string "name"
    t.string "group"
    t.text "description"
    t.integer "category"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["code"], name: "index_accounts_on_code", unique: true
  end

  create_table "people", force: :cascade do |t|
    t.string "name"
    t.string "position"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "statements", force: :cascade do |t|
    t.integer "month"
    t.integer "year"
    t.decimal "initial_balance"
    t.bigint "prepared_by_id", null: false
    t.bigint "approved_by_id", null: false
    t.datetime "finalized_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["approved_by_id"], name: "index_statements_on_approved_by_id"
    t.index ["prepared_by_id"], name: "index_statements_on_prepared_by_id"
  end

  create_table "transactions", force: :cascade do |t|
    t.bigint "statement_id", null: false
    t.string "description"
    t.string "group_name"
    t.decimal "amount"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "account_id", null: false
    t.index ["account_id"], name: "index_transactions_on_account_id"
    t.index ["statement_id"], name: "index_transactions_on_statement_id"
  end

  add_foreign_key "statements", "people", column: "approved_by_id"
  add_foreign_key "statements", "people", column: "prepared_by_id"
  add_foreign_key "transactions", "accounts"
  add_foreign_key "transactions", "statements"
end
