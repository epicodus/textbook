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

ActiveRecord::Schema.define(version: 2018_08_24_182914) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "courses", id: :serial, force: :cascade do |t|
    t.string "name", limit: 255, null: false
    t.integer "number", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "slug", limit: 255, null: false
    t.boolean "public", default: false, null: false
    t.datetime "deleted_at"
    t.boolean "dateless"
    t.integer "level"
    t.index ["deleted_at"], name: "index_courses_on_deleted_at"
    t.index ["name"], name: "index_courses_on_name", unique: true
  end

  create_table "courses_tracks", id: false, force: :cascade do |t|
    t.bigint "track_id", null: false
    t.bigint "course_id", null: false
    t.index ["course_id", "track_id"], name: "index_courses_tracks_on_course_id_and_track_id"
    t.index ["track_id", "course_id"], name: "index_courses_tracks_on_track_id_and_course_id"
  end

  create_table "lesson_sections", id: :serial, force: :cascade do |t|
    t.integer "lesson_id"
    t.integer "section_id"
    t.integer "number"
    t.datetime "deleted_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer "work_type", default: 0
    t.integer "day_of_week", default: 0
    t.index ["lesson_id"], name: "index_lesson_sections_on_lesson_id"
    t.index ["number"], name: "index_lesson_sections_on_number"
    t.index ["section_id"], name: "index_lesson_sections_on_section_id"
  end

  create_table "lessons", id: :serial, force: :cascade do |t|
    t.string "name", limit: 255, null: false
    t.text "content", null: false
    t.integer "old_section_id"
    t.integer "old_number"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "deleted_at"
    t.string "slug", limit: 255
    t.boolean "public", default: false, null: false
    t.string "video_id", limit: 255
    t.text "cheat_sheet"
    t.text "update_warning"
    t.text "markdown"
    t.boolean "old_tutorial"
    t.text "teacher_notes"
    t.string "github_path"
    t.index ["name"], name: "index_lessons_on_name"
  end

  create_table "sections", id: :serial, force: :cascade do |t|
    t.string "name", limit: 255, null: false
    t.integer "number", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "course_id", null: false
    t.string "slug", limit: 255, null: false
    t.boolean "public", default: false, null: false
    t.integer "week"
    t.datetime "deleted_at"
    t.index ["deleted_at"], name: "index_sections_on_deleted_at"
    t.index ["name"], name: "index_sections_on_name"
  end

  create_table "tracks", force: :cascade do |t|
    t.string "name"
    t.string "slug"
    t.integer "number"
    t.boolean "public"
  end

  create_table "users", id: :serial, force: :cascade do |t|
    t.string "email", limit: 255, default: "", null: false
    t.string "encrypted_password", limit: 255, default: "", null: false
    t.string "reset_password_token", limit: 255
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string "current_sign_in_ip", limit: 255
    t.string "last_sign_in_ip", limit: 255
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "author", default: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

end
