# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[8.0].define(version: 2025_03_18_005353) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "cities", id: :serial, force: :cascade do |t|
    t.string "name", null: false
    t.integer "state_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["state_id", "name"], name: "index_cities_on_state_id_and_name"
    t.index ["state_id"], name: "index_cities_on_state_id"
  end

  create_table "companies", force: :cascade do |t|
    t.string "name"
    t.string "cnpj"
    t.string "employee_count"
    t.string "work_regime"
    t.integer "max_users"
    t.boolean "active"
    t.boolean "onboarding_completed"
    t.boolean "terms_accepted"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "employees", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.bigint "company_id"
    t.bigint "office_id"
    t.bigint "team_id"
    t.string "name"
    t.string "internal_id"
    t.string "role"
    t.date "birth_date"
    t.string "phone"
    t.string "cpf"
    t.boolean "active"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "manager_id"
    t.index ["company_id"], name: "index_employees_on_company_id"
    t.index ["email"], name: "index_employees_on_email", unique: true
    t.index ["manager_id"], name: "index_employees_on_manager_id"
    t.index ["office_id"], name: "index_employees_on_office_id"
    t.index ["reset_password_token"], name: "index_employees_on_reset_password_token", unique: true
    t.index ["team_id"], name: "index_employees_on_team_id"
  end

  create_table "offices", force: :cascade do |t|
    t.bigint "company_id", null: false
    t.bigint "city_id", null: false
    t.string "name"
    t.string "zip_code"
    t.string "neighborhood"
    t.jsonb "google_infos"
    t.boolean "active"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "number"
    t.index ["city_id"], name: "index_offices_on_city_id"
    t.index ["company_id"], name: "index_offices_on_company_id"
  end

  create_table "states", id: :serial, force: :cascade do |t|
    t.string "name", null: false
    t.string "abbreviation", limit: 2, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["abbreviation"], name: "index_states_on_abbreviation", unique: true
  end

  create_table "teams", force: :cascade do |t|
    t.bigint "company_id", null: false
    t.string "name"
    t.bigint "manager_id"
    t.boolean "active"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["company_id"], name: "index_teams_on_company_id"
    t.index ["manager_id"], name: "index_teams_on_manager_id"
  end

  add_foreign_key "cities", "states"
  add_foreign_key "employees", "employees", column: "manager_id"
  add_foreign_key "offices", "cities"
  add_foreign_key "offices", "companies"
  add_foreign_key "teams", "companies"
  add_foreign_key "teams", "employees", column: "manager_id"
end
