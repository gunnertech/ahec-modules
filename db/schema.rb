# encoding: UTF-8
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

ActiveRecord::Schema.define(version: 20160620231235) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "course_general_attachments", force: :cascade do |t|
    t.datetime "created_at",            null: false
    t.datetime "updated_at",            null: false
    t.string   "document_file_name"
    t.string   "document_content_type"
    t.integer  "document_file_size"
    t.datetime "document_updated_at"
    t.integer  "course_id"
    t.text     "description"
  end

  add_index "course_general_attachments", ["course_id"], name: "index_course_general_attachments_on_course_id", using: :btree

  create_table "courses", force: :cascade do |t|
    t.datetime "created_at",                     null: false
    t.datetime "updated_at",                     null: false
    t.text     "title"
    t.text     "description"
    t.text     "question_json"
    t.integer  "minimum_score"
    t.integer  "minimum_time_spent", default: 0
    t.text     "certificate_token"
  end

  create_table "user_memberships", force: :cascade do |t|
    t.integer  "course_id"
    t.integer  "user_id"
    t.datetime "created_at",                      null: false
    t.datetime "updated_at",                      null: false
    t.boolean  "admin_approved",  default: false
    t.decimal  "course_grade",    default: 0.0
    t.integer  "course_attempts", default: 0
    t.decimal  "pretest_grade"
    t.integer  "minutes_spent",   default: 0
  end

  add_index "user_memberships", ["course_id", "user_id"], name: "index_user_memberships_on_course_id_and_user_id", unique: true, using: :btree
  add_index "user_memberships", ["course_id"], name: "index_user_memberships_on_course_id", using: :btree
  add_index "user_memberships", ["user_id"], name: "index_user_memberships_on_user_id", using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "email",                  default: "",    null: false
    t.string   "encrypted_password",     default: "",    null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,     null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.datetime "created_at",                             null: false
    t.datetime "updated_at",                             null: false
    t.boolean  "admin",                  default: false
    t.text     "address"
    t.text     "profession"
    t.text     "first_name"
    t.text     "last_name"
    t.string   "city"
    t.string   "state"
    t.string   "zip_code"
    t.string   "nabp_id"
    t.date     "dob"
    t.text     "professional_licenses"
    t.text     "social_security"
    t.text     "personal_phone"
    t.text     "employer"
    t.text     "employer_phone"
    t.text     "employer_address"
    t.text     "employer_state"
    t.text     "employer_zip"
    t.text     "employer_city"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

  create_table "video_uploads", force: :cascade do |t|
    t.string   "hosted_url"
    t.integer  "course_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "video_uploads", ["course_id"], name: "index_video_uploads_on_course_id", using: :btree

  create_table "youtube_video_ids", force: :cascade do |t|
    t.string   "video_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer  "course_id"
  end

  add_index "youtube_video_ids", ["course_id"], name: "index_youtube_video_ids_on_course_id", using: :btree

  add_foreign_key "course_general_attachments", "courses"
  add_foreign_key "video_uploads", "courses"
  add_foreign_key "youtube_video_ids", "courses"
end
