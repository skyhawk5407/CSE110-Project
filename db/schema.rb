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

ActiveRecord::Schema.define(version: 2019_05_21_215710) do

  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.integer "record_id", null: false
    t.integer "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.bigint "byte_size", null: false
    t.string "checksum", null: false
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "apartments", force: :cascade do |t|
    t.string "address", null: false
    t.string "name", null: false
    t.string "access_code", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["access_code"], name: "index_apartments_on_access_code", unique: true
  end

  create_table "documents", force: :cascade do |t|
    t.integer "apartment_id", null: false
    t.integer "expense_id"
    t.integer "user_id", null: false
    t.string "title", null: false
    t.boolean "apartmentwide", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["apartment_id"], name: "index_documents_on_apartment_id"
    t.index ["expense_id"], name: "index_documents_on_expense_id", unique: true
    t.index ["user_id"], name: "index_documents_on_user_id"
  end

  create_table "expenses", force: :cascade do |t|
    t.integer "apartment_id", null: false
    t.integer "payer_id", null: false
    t.integer "issuer_id", null: false
    t.string "title", null: false
    t.string "description", null: false
    t.integer "amount", null: false
    t.boolean "paid"
    t.datetime "paid_date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["apartment_id"], name: "index_expenses_on_apartment_id"
    t.index ["issuer_id"], name: "index_expenses_on_issuer_id"
    t.index ["payer_id"], name: "index_expenses_on_payer_id"
  end

  create_table "items", force: :cascade do |t|
    t.integer "user_id"
    t.integer "apartment_id", null: false
    t.string "name", null: false
    t.boolean "bought"
    t.string "description", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["apartment_id"], name: "index_items_on_apartment_id"
    t.index ["user_id"], name: "index_items_on_user_id"
  end

  create_table "notifications", force: :cascade do |t|
    t.integer "apartment_id", null: false
    t.integer "user_id"
    t.string "title", null: false
    t.string "message", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["apartment_id"], name: "index_notifications_on_apartment_id"
    t.index ["created_at"], name: "index_notifications_on_created_at"
    t.index ["user_id"], name: "index_notifications_on_user_id"
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
    t.string "email", null: false
    t.integer "apartment_id"
    t.string "password_digest", null: false
    t.string "reset_token", null: false
    t.string "display_name", null: false
    t.string "phone_number"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["apartment_id"], name: "index_users_on_apartment_id"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_token"], name: "index_users_on_reset_token", unique: true
  end

end
