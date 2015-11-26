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

ActiveRecord::Schema.define(version: 20151126175626) do

  create_table "admin_users", force: :cascade do |t|
    t.string   "first_name",      limit: 255, default: "",    null: false
    t.string   "last_name",       limit: 255, default: "",    null: false
    t.string   "role",            limit: 255,                 null: false
    t.string   "email",           limit: 255,                 null: false
    t.boolean  "status",                      default: false
    t.string   "token",           limit: 255,                 null: false
    t.string   "password_digest", limit: 255,                 null: false
    t.string   "preferences",     limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "admin_users", ["email"], name: "index_admin_users_on_email", unique: true, using: :btree

  create_table "logins", force: :cascade do |t|
    t.string   "userid",        limit: 255,   null: false
    t.string   "password_hash", limit: 255,   null: false
    t.string   "password_salt", limit: 255,   null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "kie",           limit: 65535
  end

  add_index "logins", ["userid"], name: "index_logins_on_userid", unique: true, using: :btree

  create_table "paints", force: :cascade do |t|
    t.string   "userid",     limit: 255, null: false
    t.integer  "category",   limit: 4,   null: false
    t.string   "title",      limit: 255, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "filedata",   limit: 255
  end

  create_table "sessions", force: :cascade do |t|
    t.string   "session_id", limit: 255,   null: false
    t.text     "data",       limit: 65535
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "sessions", ["session_id"], name: "index_sessions_on_session_id", unique: true, using: :btree
  add_index "sessions", ["updated_at"], name: "index_sessions_on_updated_at", using: :btree

end
