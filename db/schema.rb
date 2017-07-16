# This file is auto-generated from the current state of the database. Instead of editing this file,
# please use the migrations feature of Active Record to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 6) do

  create_table "anaesthetists", :force => true do |t|
    t.text    "surname",    :null => false
    t.text    "initials",   :null => false
    t.boolean "consultant", :null => false
  end

  create_table "guest_surgeons", :force => true do |t|
    t.text "name", :null => false
  end

  create_table "op_list_entries", :force => true do |t|
    t.integer  "op_list_id", :null => false
    t.datetime "updated_at", :null => false
    t.integer  "position",   :null => false
    t.text     "crn",        :null => false
    t.date     "dob",        :null => false
    t.text     "surname",    :null => false
    t.text     "forename",   :null => false
    t.text     "sex",        :null => false
    t.text     "ward",       :null => false
    t.text     "operation",  :null => false
    t.text     "notes"
  end

  create_table "op_lists", :force => true do |t|
    t.datetime "updated_at",       :null => false
    t.text     "theatre",          :null => false
    t.datetime "start_time",       :null => false
    t.text     "surgeon",          :null => false
    t.text     "anaesthetist"
    t.integer  "list_author_id"
    t.text     "list_author_type"
  end

  create_table "op_notes", :force => true do |t|

    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false

    t.text     "crn",           :null => false
    t.date     "dob",           :null => false
    t.text     "surname",       :null => false
    t.text     "forename",      :null => false
    t.text     "sex",           :null => false

    t.datetime "start_time",    :null => false
    t.datetime "end_time",      :null => false

    t.text     "cons_surg",     :null => false
    t.text     "cons_anaes",    :null => false

    t.text     "diagnosis",     :null => false
    t.text     "operation",     :null => false
    t.text     "cepod",         :null => false
    t.integer  "asa",           :null => false
    t.text     "anaesthetic",   :null => false

    t.text     "surgeon1",      :null => false
    t.text     "surgeon2"
    t.text     "surgeon3"
    t.text     "assistant1"
    t.text     "assistant2"
    t.text     "assistant3"
    t.text     "anaesthetist1"
    t.text     "anaesthetist2"
    t.text     "anaesthetist3"

    t.boolean  "dvt_lmwh",      :null => false
    t.boolean  "dvt_ted",       :null => false
    t.boolean  "dvt_pneum",     :null => false
    t.boolean  "dvt_aspirin"

    t.text     "antibiotics"
    t.text     "indication",    :null => false
    t.text     "position",      :null => false
    t.text     "incision",      :null => false
    t.text     "findings",      :null => false
    t.text     "proc_text",     :null => false
    t.text     "cancer",        :null => false
    t.text     "ebl"
    t.text     "transfusion"
    t.text     "post_op",       :null => false
  end

  create_table "op_templates", :force => true do |t|
    t.text "surgeon",   :null => false
    t.text "operation", :null => false
    t.text "position",  :null => false
    t.text "incision",  :null => false
    t.text "proc_text", :null => false
    t.text "post_op",   :null => false
  end

  create_table "users", :force => true do |t|
    t.string "username"
    t.string "password_salt"
    t.string "password_hash"
  end

end
