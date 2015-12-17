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

ActiveRecord::Schema.define(version: 20151216102728) do

  create_table "qcms", force: true do |t|
    t.text     "fullText"
    t.text     "step"
    t.text     "qcm_content"
    t.text     "qcm_answers"
    t.text     "qcm_choices"
    t.text     "user_answers"
    t.text     "is_right"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "tats", force: true do |t|
    t.text     "fullText"
    t.text     "step"
    t.text     "tat_content"
    t.text     "tat_answers"
    t.text     "user_answers"
    t.text     "is_right"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
