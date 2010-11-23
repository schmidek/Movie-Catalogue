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

ActiveRecord::Schema.define(:version => 20101119035824) do

  create_table "catalogues", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "genres", :force => true do |t|
    t.string "name"
  end

  create_table "genres_movies", :id => false, :force => true do |t|
    t.integer "movie_id"
    t.integer "genre_id"
  end

  create_table "movie_holders", :force => true do |t|
    t.integer  "catalogue_id"
    t.integer  "movie_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "movies", :force => true do |t|
    t.string   "name"
    t.string   "cover"
    t.string   "trailer"
    t.string   "imdb"
    t.integer  "year"
    t.date     "added"
    t.integer  "rating"
    t.string   "format",       :default => "Bluray"
    t.text     "summary"
    t.text     "notes"
    t.integer  "catalogue_id"
    t.boolean  "active",       :default => true,     :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "revisions", :force => true do |t|
    t.string   "change_type"
    t.text     "diff"
    t.integer  "movie_id"
    t.integer  "user_id"
    t.integer  "catalogue_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", :force => true do |t|
    t.string   "login"
    t.string   "email"
    t.string   "crypted_password"
    t.string   "password_salt"
    t.string   "persistence_token"
    t.string   "single_access_token"
    t.string   "perishable_token"
    t.integer  "login_count"
    t.integer  "failed_login_count"
    t.datetime "current_login_at"
    t.datetime "last_login_at"
    t.string   "current_login_ip"
    t.string   "last_login_ip"
    t.integer  "catalogue_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
