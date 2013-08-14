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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20130814111528) do

  create_table "admins", :force => true do |t|
    t.boolean  "stop"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "groups", :force => true do |t|
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
    t.integer  "users_number"
    t.integer  "round_id"
    t.integer  "betray_penalty"
  end

  create_table "proposals", :force => true do |t|
    t.integer  "from"
    t.integer  "group_id"
    t.integer  "round_id"
    t.decimal  "money_a"
    t.decimal  "money_b"
    t.decimal  "money_c"
    t.datetime "created_at",       :null => false
    t.datetime "updated_at",       :null => false
    t.integer  "to"
    t.boolean  "accept"
    t.integer  "submiter_penalty"
    t.integer  "accepter_penalty"
  end

  create_table "users", :force => true do |t|
    t.string   "name"
    t.string   "password_digest"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
    t.datetime "last_active"
    t.integer  "group_id"
    t.integer  "round_id"
    t.string   "auth_token"
    t.integer  "earnings"
    t.string   "plain_password"
  end

end
