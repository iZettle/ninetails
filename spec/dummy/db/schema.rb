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

ActiveRecord::Schema.define(version: 20160121135155) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "ninetails_page_revision_sections", force: :cascade do |t|
    t.integer "page_revision_id"
    t.integer "section_id"
  end

  add_index "ninetails_page_revision_sections", ["page_revision_id"], name: "index_ninetails_page_revision_sections_on_page_revision_id", using: :btree
  add_index "ninetails_page_revision_sections", ["section_id"], name: "index_ninetails_page_revision_sections_on_section_id", using: :btree

  create_table "ninetails_page_revisions", force: :cascade do |t|
    t.integer  "page_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string   "message"
    t.integer  "project_id"
  end

  create_table "ninetails_page_sections", force: :cascade do |t|
    t.string   "name"
    t.string   "type"
    t.json     "elements"
    t.json     "tags"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "ninetails_pages", force: :cascade do |t|
    t.integer  "current_revision_id"
    t.string   "name"
    t.string   "url"
    t.datetime "created_at",          null: false
    t.datetime "updated_at",          null: false
  end

  add_index "ninetails_pages", ["current_revision_id"], name: "index_ninetails_pages_on_current_revision_id", using: :btree

  create_table "ninetails_project_pages", force: :cascade do |t|
    t.integer "project_id"
    t.integer "page_id"
    t.integer "page_revision_id"
  end

  create_table "ninetails_projects", force: :cascade do |t|
    t.string "name"
    t.string "description"
  end

end
