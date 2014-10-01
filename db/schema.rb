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

ActiveRecord::Schema.define(version: 20141001035408) do

  create_table "budgets", force: true do |t|
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "budgets", ["user_id"], name: "index_budgets_on_user_id"

  create_table "default_items", force: true do |t|
    t.integer  "budget_id"
    t.integer  "day"
    t.string   "name"
    t.integer  "debit_cents",  default: 0
    t.integer  "credit_cents", default: 0
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "default_items", ["budget_id"], name: "index_default_items_on_budget_id"

  create_table "entries", force: true do |t|
    t.string   "name"
    t.date     "date"
    t.boolean  "cleared",       default: false
    t.integer  "credit_cents",  default: 0
    t.integer  "debit_cents",   default: 0
    t.integer  "register_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "balance_cents", default: 0
    t.integer  "rank"
  end

  add_index "entries", ["rank"], name: "index_entries_on_rank"
  add_index "entries", ["register_id"], name: "index_entries_on_register_id"

  create_table "registers", force: true do |t|
    t.string   "name"
    t.string   "acctnumber"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "startbalance_cents",      default: 0
    t.integer  "available_balance_cents", default: 0
    t.integer  "cleared_balance_cents",   default: 0
  end

  add_index "registers", ["user_id"], name: "index_registers_on_user_id"

end
