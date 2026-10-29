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

ActiveRecord::Schema[8.1].define(version: 2026_10_27_211928) do
  create_table "badges", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "name"
    t.integer "required_event"
    t.integer "required_points"
    t.datetime "updated_at", null: false
  end

  create_table "event_feedbacks", force: :cascade do |t|
    t.text "comment"
    t.datetime "created_at", null: false
    t.bigint "event_id", null: false
    t.integer "rating"
    t.datetime "updated_at", null: false
    t.bigint "volunteer_id", null: false
    t.index ["event_id"], name: "index_event_feedbacks_on_event_id"
    t.index ["volunteer_id"], name: "index_event_feedbacks_on_volunteer_id"
  end

  create_table "event_registrations", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.bigint "event_id", null: false
    t.datetime "registered_at"
    t.string "status"
    t.datetime "updated_at", null: false
    t.bigint "volunteer_id", null: false
    t.index ["event_id", "volunteer_id"], name: "index_event_registrations_on_event_id_and_volunteer_id", unique: true
    t.index ["event_id"], name: "index_event_registrations_on_event_id"
    t.index ["volunteer_id"], name: "index_event_registrations_on_volunteer_id"
  end

  create_table "events", force: :cascade do |t|
    t.boolean "cancelled", default: false
    t.integer "capacity"
    t.datetime "created_at", null: false
    t.text "description"
    t.datetime "event_date"
    t.string "interest_needed"
    t.string "name"
    t.bigint "organizer_id", null: false
    t.string "skill_needed"
    t.datetime "updated_at", null: false
    t.string "cancellation_reason"
    t.index ["organizer_id"], name: "index_events_on_organizer_id"
  end

  create_table "notifications", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "message"
    t.string "notification_type"
    t.boolean "read", default: false
    t.bigint "recipient_id", null: false
    t.string "recipient_type", null: false
    t.datetime "updated_at", null: false
    t.index ["recipient_type", "recipient_id"], name: "index_notifications_on_recipient"
  end

  create_table "organizers", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "name"
    t.datetime "updated_at", null: false
  end

  create_table "sessions", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "ip_address"
    t.datetime "updated_at", null: false
    t.string "user_agent"
    t.bigint "user_id", null: false
    t.index ["user_id"], name: "index_sessions_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "email_address", null: false
    t.string "password_digest", null: false
    t.datetime "updated_at", null: false
    t.bigint "userable_id", null: false
    t.string "userable_type", null: false
    t.index ["email_address"], name: "index_users_on_email_address", unique: true
    t.index ["userable_type", "userable_id"], name: "index_users_on_userable", unique: true
  end

  create_table "volunteers", force: :cascade do |t|
    t.bigint "badge_id"
    t.datetime "created_at", null: false
    t.string "interest"
    t.string "name"
    t.integer "points", default: 0
    t.string "skill"
    t.string "surname"
    t.datetime "updated_at", null: false
    t.index ["badge_id"], name: "index_volunteers_on_badge_id"
  end

  add_foreign_key "event_feedbacks", "events"
  add_foreign_key "event_feedbacks", "volunteers"
  add_foreign_key "event_registrations", "events"
  add_foreign_key "event_registrations", "volunteers"
  add_foreign_key "events", "organizers"
  add_foreign_key "sessions", "users"
  add_foreign_key "volunteers", "badges"
end
