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

ActiveRecord::Schema[8.1].define(version: 2026_07_28_110503) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "active_storage_attachments", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.string "name", null: false
    t.bigint "record_id", null: false
    t.string "record_type", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.bigint "byte_size", null: false
    t.string "checksum"
    t.string "content_type"
    t.datetime "created_at", null: false
    t.string "filename", null: false
    t.string "key", null: false
    t.text "metadata"
    t.string "service_name", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "addresses", force: :cascade do |t|
    t.string "contact_email"
    t.string "contact_name"
    t.string "contact_phone"
    t.datetime "created_at", null: false
    t.string "name"
    t.text "notes"
    t.string "postcode", null: false
    t.string "state", default: "NSW", null: false
    t.string "street_address", null: false
    t.string "suburb", null: false
    t.datetime "updated_at", null: false
    t.index ["suburb", "postcode"], name: "index_addresses_on_suburb_and_postcode"
  end

  create_table "asset_inspection_records", force: :cascade do |t|
    t.text "action_required"
    t.bigint "asset_id", null: false
    t.datetime "created_at", null: false
    t.text "defect_found"
    t.integer "defect_status", default: 4, null: false
    t.bigint "inspection_visit_id", null: false
    t.datetime "updated_at", null: false
    t.index ["asset_id", "inspection_visit_id"], name: "idx_on_asset_id_inspection_visit_id_6a15652ace", unique: true
    t.index ["asset_id"], name: "index_asset_inspection_records_on_asset_id"
    t.index ["defect_status"], name: "index_asset_inspection_records_on_defect_status"
    t.index ["inspection_visit_id"], name: "index_asset_inspection_records_on_inspection_visit_id"
  end

  create_table "assets", force: :cascade do |t|
    t.boolean "active", default: true, null: false
    t.bigint "address_id", null: false
    t.string "area"
    t.string "asset_no", null: false
    t.bigint "building_id"
    t.integer "category", null: false
    t.datetime "created_at", null: false
    t.jsonb "details", default: {}, null: false
    t.string "level"
    t.datetime "updated_at", null: false
    t.index ["address_id", "asset_no"], name: "index_assets_on_address_id_and_asset_no", unique: true
    t.index ["address_id"], name: "index_assets_on_address_id"
    t.index ["building_id"], name: "index_assets_on_building_id"
    t.index ["category"], name: "index_assets_on_category"
    t.index ["details"], name: "index_assets_on_details", using: :gin
  end

  create_table "buildings", force: :cascade do |t|
    t.bigint "address_id", null: false
    t.datetime "created_at", null: false
    t.string "name", null: false
    t.datetime "updated_at", null: false
    t.index ["address_id", "name"], name: "index_buildings_on_address_id_and_name", unique: true
    t.index ["address_id"], name: "index_buildings_on_address_id"
  end

  create_table "defects", force: :cascade do |t|
    t.bigint "asset_id", null: false
    t.bigint "asset_inspection_record_id"
    t.string "assigned_to"
    t.datetime "created_at", null: false
    t.text "description", null: false
    t.integer "priority", default: 1, null: false
    t.string "quote_reference"
    t.date "resolved_on"
    t.date "scheduled_on"
    t.integer "status", default: 0, null: false
    t.datetime "updated_at", null: false
    t.index ["asset_id"], name: "index_defects_on_asset_id"
    t.index ["asset_inspection_record_id"], name: "index_defects_on_asset_inspection_record_id"
    t.index ["priority"], name: "index_defects_on_priority"
    t.index ["status"], name: "index_defects_on_status"
  end

  create_table "inspection_visits", force: :cascade do |t|
    t.bigint "address_id", null: false
    t.datetime "created_at", null: false
    t.string "inspector_name"
    t.integer "status", default: 0, null: false
    t.text "summary_notes"
    t.datetime "updated_at", null: false
    t.date "visit_date", null: false
    t.index ["address_id", "visit_date"], name: "index_inspection_visits_on_address_id_and_visit_date"
    t.index ["address_id"], name: "index_inspection_visits_on_address_id"
    t.index ["visit_date"], name: "index_inspection_visits_on_visit_date"
  end

  create_table "schedule_completions", force: :cascade do |t|
    t.date "completed_on", null: false
    t.datetime "created_at", null: false
    t.bigint "inspection_visit_id", null: false
    t.bigint "schedule_id", null: false
    t.datetime "updated_at", null: false
    t.index ["inspection_visit_id"], name: "index_schedule_completions_on_inspection_visit_id"
    t.index ["schedule_id", "inspection_visit_id"], name: "idx_schedule_completions_unique", unique: true
    t.index ["schedule_id"], name: "index_schedule_completions_on_schedule_id"
  end

  create_table "schedules", force: :cascade do |t|
    t.boolean "active", default: true, null: false
    t.bigint "address_id", null: false
    t.bigint "building_id"
    t.datetime "created_at", null: false
    t.text "description"
    t.integer "equipment_category"
    t.integer "frequency", default: 0, null: false
    t.integer "grace_period_days", default: 7, null: false
    t.date "last_completed_on"
    t.date "next_due_on", null: false
    t.date "start_date", null: false
    t.datetime "updated_at", null: false
    t.index ["address_id", "equipment_category"], name: "index_schedules_on_address_id_and_equipment_category"
    t.index ["address_id"], name: "index_schedules_on_address_id"
    t.index ["building_id"], name: "index_schedules_on_building_id"
    t.index ["next_due_on"], name: "index_schedules_on_next_due_on"
  end

  create_table "users", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "email", null: false
    t.string "name", null: false
    t.string "password_digest", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "asset_inspection_records", "assets"
  add_foreign_key "asset_inspection_records", "inspection_visits"
  add_foreign_key "assets", "addresses"
  add_foreign_key "assets", "buildings"
  add_foreign_key "buildings", "addresses"
  add_foreign_key "defects", "asset_inspection_records"
  add_foreign_key "defects", "assets"
  add_foreign_key "inspection_visits", "addresses"
  add_foreign_key "schedule_completions", "inspection_visits"
  add_foreign_key "schedule_completions", "schedules"
  add_foreign_key "schedules", "addresses"
  add_foreign_key "schedules", "buildings"
end
