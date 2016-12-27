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

ActiveRecord::Schema.define(version: 20161227090949) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "ninetails_containers", force: :cascade do |t|
    t.integer  "current_revision_id"
    t.string   "name"
    t.datetime "created_at",                                      null: false
    t.datetime "updated_at",                                      null: false
    t.string   "type",                default: "Ninetails::Page"
    t.integer  "layout_id"
    t.string   "locale"
    t.datetime "deleted_at"
    t.index ["current_revision_id"], name: "index_ninetails_containers_on_current_revision_id", using: :btree
    t.index ["deleted_at"], name: "index_ninetails_containers_on_deleted_at", using: :btree
    t.index ["layout_id"], name: "index_ninetails_containers_on_layout_id", using: :btree
  end

  create_table "ninetails_content_sections", force: :cascade do |t|
    t.string   "name"
    t.string   "type"
    t.json     "elements",   default: {}
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
    t.string   "variant"
    t.json     "settings",   default: {}
  end

  create_table "ninetails_links", force: :cascade do |t|
    t.integer "container_id"
    t.integer "linked_container_id"
    t.string  "relationship"
    t.index ["container_id"], name: "index_ninetails_links_on_container_id", using: :btree
    t.index ["linked_container_id"], name: "index_ninetails_links_on_linked_container_id", using: :btree
  end

  create_table "ninetails_project_containers", force: :cascade do |t|
    t.integer "project_id"
    t.integer "container_id"
    t.integer "revision_id"
    t.index ["container_id"], name: "index_ninetails_project_containers_on_container_id", using: :btree
    t.index ["project_id"], name: "index_ninetails_project_containers_on_project_id", using: :btree
    t.index ["revision_id"], name: "index_ninetails_project_containers_on_revision_id", using: :btree
  end

  create_table "ninetails_projects", force: :cascade do |t|
    t.string  "name"
    t.string  "description"
    t.boolean "published",   default: false
  end

  create_table "ninetails_revision_sections", force: :cascade do |t|
    t.integer "revision_id"
    t.integer "section_id"
    t.index ["revision_id"], name: "index_ninetails_revision_sections_on_revision_id", using: :btree
    t.index ["section_id"], name: "index_ninetails_revision_sections_on_section_id", using: :btree
  end

  create_table "ninetails_revisions", force: :cascade do |t|
    t.integer  "container_id"
    t.datetime "created_at",                   null: false
    t.datetime "updated_at",                   null: false
    t.string   "message"
    t.integer  "project_id"
    t.string   "url"
    t.boolean  "published",    default: false
    t.index ["container_id"], name: "index_ninetails_revisions_on_container_id", using: :btree
    t.index ["project_id"], name: "index_ninetails_revisions_on_project_id", using: :btree
  end

end
