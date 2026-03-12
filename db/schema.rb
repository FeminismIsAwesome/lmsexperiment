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

ActiveRecord::Schema[8.1].define(version: 2026_03_12_052758) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "action_text_rich_texts", force: :cascade do |t|
    t.text "body"
    t.datetime "created_at", null: false
    t.string "name", null: false
    t.bigint "record_id", null: false
    t.string "record_type", null: false
    t.datetime "updated_at", null: false
    t.index ["record_type", "record_id", "name"], name: "index_action_text_rich_texts_uniqueness", unique: true
  end

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

  create_table "events", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "event_type"
    t.bigint "game_id", null: false
    t.string "session_hash"
    t.datetime "updated_at", null: false
    t.index ["game_id"], name: "index_events_on_game_id"
  end

  create_table "games", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "game_type"
    t.bigint "lesson_id", null: false
    t.json "options"
    t.integer "position"
    t.string "title"
    t.datetime "updated_at", null: false
    t.index ["lesson_id"], name: "index_games_on_lesson_id"
  end

  create_table "lessons", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "title"
    t.datetime "updated_at", null: false
  end

  create_table "page_translations", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "locale", null: false
    t.bigint "page_id", null: false
    t.string "title", null: false
    t.datetime "updated_at", null: false
    t.index ["page_id", "locale"], name: "index_page_translations_on_page_id_and_locale", unique: true
    t.index ["page_id"], name: "index_page_translations_on_page_id"
  end

  create_table "page_views", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.bigint "page_id", null: false
    t.string "session_hash"
    t.datetime "updated_at", null: false
    t.index ["page_id"], name: "index_page_views_on_page_id"
  end

  create_table "pages", force: :cascade do |t|
    t.text "content"
    t.datetime "created_at", null: false
    t.bigint "lesson_id", null: false
    t.integer "position"
    t.string "title"
    t.datetime "updated_at", null: false
    t.index ["lesson_id"], name: "index_pages_on_lesson_id"
  end

  create_table "question_options", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.bigint "question_id", null: false
    t.string "text"
    t.datetime "updated_at", null: false
    t.index ["question_id"], name: "index_question_options_on_question_id"
  end

  create_table "question_responses", force: :cascade do |t|
    t.text "answer_text"
    t.datetime "created_at", null: false
    t.bigint "question_id", null: false
    t.bigint "question_option_id"
    t.string "session_hash"
    t.datetime "updated_at", null: false
    t.index ["question_id"], name: "index_question_responses_on_question_id"
    t.index ["question_option_id"], name: "index_question_responses_on_question_option_id"
  end

  create_table "questions", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.boolean "multiple_answers", default: false, null: false
    t.bigint "page_id", null: false
    t.string "question_type", default: "multiple_choice", null: false
    t.string "text"
    t.datetime "updated_at", null: false
    t.index ["page_id"], name: "index_questions_on_page_id"
  end

  create_table "users", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.datetime "remember_created_at"
    t.datetime "reset_password_sent_at"
    t.string "reset_password_token"
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "events", "games"
  add_foreign_key "games", "lessons"
  add_foreign_key "page_translations", "pages"
  add_foreign_key "page_views", "pages"
  add_foreign_key "pages", "lessons"
  add_foreign_key "question_options", "questions"
  add_foreign_key "question_responses", "question_options"
  add_foreign_key "question_responses", "questions"
  add_foreign_key "questions", "pages"
end
