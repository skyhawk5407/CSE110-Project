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

ActiveRecord::Schema.define(version: 2019_05_05_045622) do

  create_table "apartment_mates", force: :cascade do |t|
    t.integer "user_id"
    t.integer "apartment_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["apartment_id"], name: "index_apartment_mates_on_apartment_id"
    t.index ["user_id"], name: "index_apartment_mates_on_user_id"
  end

  create_table "apartment_rules", force: :cascade do |t|
    t.integer "apartment_id"
    t.string "rule"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["apartment_id"], name: "index_apartment_rules_on_apartment_id"
  end

  create_table "apartments", force: :cascade do |t|
    t.string "address"
    t.string "name"
    t.integer "user_id"
    t.string "items"
    t.string "access_code"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_apartments_on_user_id"
  end

  create_table "documents", force: :cascade do |t|
    t.integer "apartment_id"
    t.integer "expense_id"
    t.string "title"
    t.string "filename"
    t.boolean "apartmentwide"
    t.datetime "upload_date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["apartment_id"], name: "index_documents_on_apartment_id"
    t.index ["expense_id"], name: "index_documents_on_expense_id"
  end

  create_table "expenses", force: :cascade do |t|
    t.integer "apartment_id"
    t.integer "payer_id"
    t.integer "issuer_id"
    t.integer "amount"
    t.boolean "paid"
    t.boolean "verified"
    t.datetime "verified_date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["apartment_id"], name: "index_expenses_on_apartment_id"
    t.index ["issuer_id"], name: "index_expenses_on_issuer_id"
    t.index ["payer_id"], name: "index_expenses_on_payer_id"
  end

  create_table "notifications", force: :cascade do |t|
    t.integer "apartment_id"
    t.integer "user_id"
    t.string "message"
    t.datetime "sent_date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["apartment_id"], name: "index_notifications_on_apartment_id"
    t.index ["user_id"], name: "index_notifications_on_user_id"
  end

  create_table "sessions", force: :cascade do |t|
    t.string "identifier"
    t.integer "user_id"
    t.datetime "expiry"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_sessions_on_user_id"
  end

  create_table "unread_notifications", force: :cascade do |t|
    t.integer "user_id"
    t.integer "notification_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["notification_id"], name: "index_unread_notifications_on_notification_id"
    t.index ["user_id"], name: "index_unread_notifications_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "username"
    t.string "password"
    t.string "reset_token"
    t.string "first_name"
    t.string "last_name"
    t.string "email"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

end
