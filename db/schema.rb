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

ActiveRecord::Schema.define(version: 20141122203937) do

  create_table "articles", force: true do |t|
    t.string   "title"
    t.text     "body"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "compañias", primary_key: "Id_compañia", force: true do |t|
    t.string "Nombre",   limit: 144, null: false
    t.string "Cuenta",   limit: 144, null: false
    t.string "Cantidad", limit: 45
  end

  create_table "diccionario", primary_key: "Id_diccionario", force: true do |t|
    t.string "Terminos", limit: 144, null: false
  end

  create_table "local", primary_key: "Id_local", force: true do |t|
    t.string "Region", limit: 144, null: false
  end

  create_table "reclamos", primary_key: "Id_tweet", force: true do |t|
    t.integer "Id_compañia",             null: false
    t.string  "Tipo",        limit: 144, null: false
    t.string  "Servicio",    limit: 144, null: false
  end

  add_index "reclamos", ["Id_compañia"], name: "fk_Twitt_has_Compañias_Compañias1_idx"
  add_index "reclamos", ["Id_tweet", "Id_compañia"], name: "sqlite_autoindex_reclamos_1", unique: true
  add_index "reclamos", ["Id_tweet"], name: "fk_Twitt_has_Compañias_Twitt_idx"

  create_table "tweet", primary_key: "Id_tweet", force: true do |t|
    t.string  "Contenido",           limit: 144, null: false
    t.date    "Fecha"
    t.integer "Iddiccionario_tweet"
  end

  add_index "tweet", ["Iddiccionario_tweet"], name: "fk_Twitt_DIccionario1_idx"

  create_table "usuario", primary_key: "Id_usuario", force: true do |t|
    t.string  "Email",    limit: 45
    t.string  "Nombre_u", limit: 144
    t.string  "Nick",     limit: 144
    t.string  "Sexo",     limit: 144
    t.integer "Id_local"
  end

  add_index "usuario", ["Id_local"], name: "fk_Usuario_Local1_idx"

  create_table "usuariotweet", primary_key: "Id_usuario", force: true do |t|
    t.integer "Id_tweet", null: false
  end

  add_index "usuariotweet", ["Id_tweet"], name: "fk_Usuario_has_Tweet_Tweet1_idx"
  add_index "usuariotweet", ["Id_usuario", "Id_tweet"], name: "sqlite_autoindex_usuariotweet_1", unique: true
  add_index "usuariotweet", ["Id_usuario"], name: "fk_Usuario_has_Tweet_Usuario1_idx"

end
