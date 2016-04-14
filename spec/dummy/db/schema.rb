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

ActiveRecord::Schema.define(version: 20160414122755) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "ninetails_containers", force: :cascade do |t|
    t.integer  "current_revision_id"
    t.string   "name"
    t.string   "url"
    t.datetime "created_at",                      null: false
    t.datetime "updated_at",                      null: false
    t.integer  "type",                default: 0
  end

  add_index "ninetails_containers", ["current_revision_id"], name: "ninetails_containers_on_current_revision_id", using: :btree

  create_table "ninetails_content_sections", force: :cascade do |t|
    t.string   "name"
    t.string   "type"
    t.json     "elements"
    t.json     "tags"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "ninetails_project_containers", force: :cascade do |t|
    t.integer "project_id"
    t.integer "container_id"
    t.integer "revision_id"
  end

  create_table "ninetails_projects", force: :cascade do |t|
    t.string  "name"
    t.string  "description"
    t.boolean "published",   default: false
  end

  create_table "ninetails_revision_sections", force: :cascade do |t|
    t.integer "revision_id"
    t.integer "section_id"
  end

  add_index "ninetails_revision_sections", ["revision_id"], name: "ninetails_revision_sections_on_revision_id", using: :btree
  add_index "ninetails_revision_sections", ["section_id"], name: "ninetails_revision_sections_on_section_id", using: :btree

  create_table "ninetails_revisions", force: :cascade do |t|
    t.integer  "container_id"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
    t.string   "message"
    t.integer  "project_id"
  end

end
