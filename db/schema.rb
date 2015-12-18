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

ActiveRecord::Schema.define(version: 20151217224358) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "courses", force: :cascade do |t|
    t.string   "name",       limit: 255,                 null: false
    t.integer  "number",                                 null: false
    t.datetime "created_at",                             null: false
    t.datetime "updated_at",                             null: false
    t.string   "slug",       limit: 255,                 null: false
    t.boolean  "public",                 default: false, null: false
  end

  add_index "courses", ["name"], name: "index_courses_on_name", unique: true, using: :btree

  create_table "lesson_sections", force: :cascade do |t|
    t.integer  "lesson_id"
    t.integer  "section_id"
    t.integer  "number"
    t.datetime "deleted_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "work_type",  default: 0
  end

  add_index "lesson_sections", ["lesson_id"], name: "index_lesson_sections_on_lesson_id", using: :btree
  add_index "lesson_sections", ["number"], name: "index_lesson_sections_on_number", using: :btree
  add_index "lesson_sections", ["section_id"], name: "index_lesson_sections_on_section_id", using: :btree

  create_table "lessons", force: :cascade do |t|
    t.string   "name",           limit: 255,                 null: false
    t.text     "content",                                    null: false
    t.integer  "old_section_id"
    t.integer  "old_number"
    t.datetime "created_at",                                 null: false
    t.datetime "updated_at",                                 null: false
    t.datetime "deleted_at"
    t.string   "slug",           limit: 255,                 null: false
    t.boolean  "public",                     default: false, null: false
    t.string   "video_id",       limit: 255
    t.text     "cheat_sheet"
    t.text     "update_warning"
    t.text     "markdown"
    t.boolean  "old_tutorial"
  end

  add_index "lessons", ["name"], name: "index_lessons_on_name", unique: true, using: :btree

  create_table "sections", force: :cascade do |t|
    t.string   "name",       limit: 255,                 null: false
    t.integer  "number",                                 null: false
    t.datetime "created_at",                             null: false
    t.datetime "updated_at",                             null: false
    t.integer  "course_id",                              null: false
    t.string   "slug",       limit: 255,                 null: false
    t.boolean  "public",                 default: false, null: false
    t.integer  "week"
  end

  add_index "sections", ["name"], name: "index_sections_on_name", unique: true, using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "email",                  limit: 255, default: "",    null: false
    t.string   "encrypted_password",     limit: 255, default: "",    null: false
    t.string   "reset_password_token",   limit: 255
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                      default: 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip",     limit: 255
    t.string   "last_sign_in_ip",        limit: 255
    t.datetime "created_at",                                         null: false
    t.datetime "updated_at",                                         null: false
    t.boolean  "author",                             default: false
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

end
