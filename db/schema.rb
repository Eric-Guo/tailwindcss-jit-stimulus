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

ActiveRecord::Schema[7.0].define(version: 2022_06_30_093500) do
  create_table "application_sites", id: { type: :bigint, unsigned: true }, charset: "utf8", force: :cascade do |t|
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.datetime "deleted_at", precision: nil
    t.string "name", limit: 191
    t.index ["deleted_at"], name: "idx_application_sites_deleted_at"
  end

  create_table "aq_manufacturers", id: { type: :bigint, unsigned: true }, charset: "utf8", force: :cascade do |t|
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.datetime "deleted_at", precision: nil
    t.bigint "manufacturer_id", unsigned: true
    t.string "name", limit: 191
    t.string "logo", limit: 191
    t.string "main_materials", limit: 191
    t.string "main_material_remark", limit: 191
    t.string "location", limit: 191
    t.string "contact", limit: 191
    t.string "email", limit: 191
    t.string "legal_email", limit: 191
    t.string "legal", limit: 191
    t.string "position", limit: 191
    t.string "registered_capital", limit: 191
    t.string "contact_information", limit: 191
    t.string "office_phone", limit: 191
    t.string "website", limit: 191
    t.string "address", limit: 191
    t.string "source", limit: 191
    t.text "brands", size: :long
    t.index ["deleted_at"], name: "idx_aq_manufacturers_deleted_at"
  end

  create_table "architecture_positions", charset: "utf8", force: :cascade do |t|
    t.string "category"
    t.string "code"
    t.string "title"
    t.integer "level"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["code"], name: "index_architecture_positions_on_code"
  end

  create_table "areas", id: { type: :bigint, unsigned: true }, charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.datetime "deleted_at", precision: nil
    t.string "title", limit: 191
    t.string "letter", limit: 191
    t.bigint "area_id", unsigned: true
    t.bigint "sort"
    t.bigint "page_int"
    t.string "full_title", limit: 191
    t.index ["deleted_at"], name: "idx_areas_deleted_at"
  end

  create_table "bids", id: { type: :bigint, unsigned: true }, charset: "utf8mb4", collation: "utf8mb4_general_ci", force: :cascade do |t|
    t.boolean "taken"
    t.text "amount", size: :long
    t.datetime "deadlined_at", precision: 3
    t.datetime "created_at", precision: 3
    t.datetime "updated_at", precision: 3
    t.text "deadlined_at_str", size: :long
    t.index ["created_at"], name: "idx_bids_created_at"
    t.index ["deadlined_at"], name: "idx_bids_deadlined_at"
    t.index ["updated_at"], name: "idx_bids_updated_at"
  end

  create_table "brands", id: { type: :bigint, unsigned: true }, charset: "utf8", force: :cascade do |t|
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.datetime "deleted_at", precision: nil
    t.string "brand_name", limit: 191
    t.string "logo", limit: 191
    t.string "site", limit: 191
    t.string "product", limit: 191
    t.string "address", limit: 191
    t.text "description", size: :long
    t.string "region", limit: 191
    t.string "aq_online_id", limit: 191
    t.index ["deleted_at"], name: "idx_brands_deleted_at"
  end

  create_table "casbin_rule", id: false, charset: "utf8mb4", collation: "utf8mb4_general_ci", force: :cascade do |t|
    t.string "p_type", limit: 100
    t.string "v0", limit: 100
    t.string "v1", limit: 100
    t.string "v2", limit: 100
    t.string "v3", limit: 100
    t.string "v4", limit: 100
    t.string "v5", limit: 100
  end

  create_table "case_delegate_records", id: { type: :bigint, unsigned: true }, charset: "utf8", force: :cascade do |t|
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.datetime "deleted_at", precision: nil
    t.bigint "lmkzsc_id", unsigned: true
    t.bigint "case_id", unsigned: true
    t.string "project_name"
    t.string "en_name"
    t.bigint "area_id", comment: "地区", unsigned: true
    t.string "web_cover", limit: 191
    t.string "web_cover_desc", limit: 191
    t.integer "is_th", limit: 1, comment: "是否天华项目"
    t.integer "is_jzw", limit: 1, comment: "是否天华项目"
    t.string "jzw_url", limit: 191
    t.string "th_no", limit: 191
    t.string "no", limit: 32
    t.string "business_type", limit: 191
    t.string "project_type", limit: 191
    t.string "project_location", limit: 191
    t.string "design_unit", limit: 191
    t.string "build_unit", limit: 191
    t.string "finish_year", limit: 191
    t.boolean "is_da"
    t.string "ecm_files", limit: 191
    t.string "ecm_documents", limit: 191
    t.string "ecm_desc", limit: 191
    t.string "live_photos", limit: 191
    t.json "documents", comment: "实景照"
    t.bigint "display", comment: "分类/产品id"
    t.string "source", limit: 191
    t.bigint "cl_online_id"
    t.bigint "zz_online_id"
    t.text "content", size: :long
    t.string "source_web_cover", limit: 191
    t.string "cover", limit: 191
    t.string "source_cover", limit: 191
    t.string "record_type", limit: 191
    t.string "confidentiality_agreement_name", limit: 191
    t.integer "visibility", limit: 1
    t.string "confidentiality_agreement_path", limit: 191
    t.string "confidential_time", limit: 191
    t.string "confidentiality_agreement_size", limit: 191
    t.index ["deleted_at"], name: "idx_case_delegate_records_deleted_at"
  end

  create_table "case_delegates", id: { type: :bigint, unsigned: true }, charset: "utf8", force: :cascade do |t|
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.datetime "deleted_at", precision: nil
    t.bigint "case_id", unsigned: true
    t.string "jzw_id", limit: 191
    t.bigint "delegate_user_id", unsigned: true
    t.string "remark", limit: 191
    t.string "status", limit: 191
    t.bigint "department_id", unsigned: true
    t.datetime "closed_at", precision: nil
    t.bigint "user_id", unsigned: true
    t.bigint "sys_user_id", unsigned: true
    t.bigint "editor_id", unsigned: true
    t.bigint "case_delegate_record_id", unsigned: true
    t.boolean "is_user_cases"
    t.index ["deleted_at"], name: "idx_case_delegates_deleted_at"
  end

  create_table "case_design_photos", id: { type: :bigint, unsigned: true }, charset: "utf8", force: :cascade do |t|
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.datetime "deleted_at", precision: nil
    t.string "title", limit: 191
    t.bigint "case_id", unsigned: true
    t.bigint "case_delegate_record_id", unsigned: true
    t.string "path", limit: 191
    t.string "cover", limit: 191
    t.string "source_path", limit: 191
    t.string "source_cover", limit: 191
    t.index ["deleted_at"], name: "idx_case_design_photos_deleted_at"
  end

  create_table "case_examines", id: { type: :bigint, unsigned: true }, charset: "utf8", force: :cascade do |t|
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.datetime "deleted_at", precision: nil
    t.bigint "case_id", unsigned: true
    t.bigint "examine_user_id", unsigned: true
    t.bigint "user_id", unsigned: true
    t.string "examine_user_name", limit: 191
    t.string "remark", limit: 191
    t.bigint "revoked_user_id"
    t.datetime "revoked_at", precision: nil
    t.datetime "rejected_at", precision: nil
    t.datetime "approved_at", precision: nil
    t.string "status", limit: 191
    t.string "type_id", limit: 191
    t.string "user_name", limit: 191
    t.datetime "closed_at", precision: nil
    t.bigint "case_delegate_id", unsigned: true
    t.string "unpublish_info", limit: 191
    t.string "rejected_content", limit: 191
    t.binary "data", size: :long
    t.bigint "case_delegate_record_id", unsigned: true
    t.index ["deleted_at"], name: "idx_case_examines_deleted_at"
  end

  create_table "case_live_photos", id: { type: :bigint, unsigned: true }, charset: "utf8", force: :cascade do |t|
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.datetime "deleted_at", precision: nil
    t.string "title", limit: 191
    t.bigint "case_id", unsigned: true
    t.bigint "case_delegate_record_id", unsigned: true
    t.string "path", limit: 191
    t.string "cover", limit: 191
    t.string "source_path", limit: 191
    t.string "source_cover", limit: 191
    t.index ["deleted_at"], name: "idx_case_live_photos_deleted_at"
  end

  create_table "case_manufacturers", primary_key: ["cases_id", "manufacturer_id"], charset: "utf8", force: :cascade do |t|
    t.bigint "cases_id", null: false, unsigned: true
    t.bigint "manufacturer_id", null: false, unsigned: true
  end

  create_table "case_material_color_systems", primary_key: ["cases_material_id", "color_systems_id"], charset: "utf8mb4", collation: "utf8mb4_bin", force: :cascade do |t|
    t.bigint "cases_material_id", null: false, unsigned: true
    t.bigint "color_systems_id", null: false, unsigned: true
  end

  create_table "case_material_samples", primary_key: ["cases_material_id", "sample_id"], charset: "utf8", force: :cascade do |t|
    t.bigint "cases_material_id", null: false, unsigned: true
    t.bigint "sample_id", null: false, unsigned: true
  end

  create_table "case_material_surface_effects", primary_key: ["cases_material_id", "surface_effect_id"], charset: "utf8mb4", collation: "utf8mb4_bin", force: :cascade do |t|
    t.bigint "cases_material_id", null: false, unsigned: true
    t.bigint "surface_effect_id", null: false, unsigned: true
  end

  create_table "case_record_manufacturers", primary_key: ["case_delegate_record_id", "manufacturer_id"], charset: "utf8", force: :cascade do |t|
    t.bigint "case_delegate_record_id", null: false, unsigned: true
    t.bigint "manufacturer_id", null: false, unsigned: true
  end

  create_table "case_relevant_documents", id: { type: :bigint, unsigned: true }, charset: "utf8", force: :cascade do |t|
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.datetime "deleted_at", precision: nil
    t.string "title", limit: 191
    t.bigint "case_id", unsigned: true
    t.bigint "case_delegate_record_id"
    t.string "path", limit: 191
    t.bigint "type_id", unsigned: true
    t.index ["deleted_at"], name: "idx_case_relevant_documents_deleted_at"
  end

  create_table "cases", id: { type: :bigint, unsigned: true }, charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.datetime "deleted_at", precision: nil
    t.string "project_name", comment: "'项目名称'"
    t.boolean "is_th"
    t.string "case_no", limit: 191
    t.string "business_type", limit: 191
    t.string "project_type", limit: 191
    t.string "project_location", limit: 191
    t.string "design_unit", limit: 191
    t.string "build_unit", limit: 191
    t.string "finish_year", limit: 191
    t.boolean "is_da"
    t.json "ecm_files"
    t.json "ecm_documents"
    t.string "ecm_desc", limit: 500, comment: "'立面控制手册资料包说明'"
    t.json "live_photos"
    t.json "documents"
    t.string "no", limit: 32, comment: "'案例编号'"
    t.bigint "sys_user_id", unsigned: true
    t.bigint "cl_online_id", unsigned: true
    t.bigint "display"
    t.string "source", limit: 191
    t.string "web_cover", limit: 191
    t.integer "top_at"
    t.text "content"
    t.string "en_name", comment: "'项目名称'"
    t.bigint "area_id", unsigned: true
    t.string "jzw_url", limit: 191
    t.string "th_no", limit: 191
    t.boolean "is_jzw"
    t.bigint "zz_online_id", unsigned: true
    t.bigint "cybros_user_id", unsigned: true
    t.string "cover", limit: 191
    t.string "web_cover_desc", limit: 191
    t.bigint "lmkzsc_id", unsigned: true
    t.string "status", limit: 191
    t.datetime "published_at", precision: nil
    t.string "source_cover", limit: 191
    t.string "source_web_cover", limit: 191
    t.boolean "is_external_case"
    t.string "confidential_time", limit: 191
    t.string "confidentiality_agreement_path", limit: 191
    t.integer "visibility", limit: 1
    t.string "confidentiality_agreement_size", limit: 191
    t.string "confidentiality_agreement_name", limit: 191
    t.index ["deleted_at"], name: "idx_cases_deleted_at"
  end

  create_table "cases_copy1", id: { type: :bigint, unsigned: true }, charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.datetime "deleted_at", precision: nil
    t.string "project_name", limit: 191
    t.boolean "is_th"
    t.string "case_no", limit: 191
    t.string "business_type", limit: 191
    t.string "project_type", limit: 191
    t.string "project_location", limit: 191
    t.string "design_unit", limit: 191
    t.string "build_unit", limit: 191
    t.string "finish_year", limit: 191
    t.boolean "is_da"
    t.json "ecm_files"
    t.json "ecm_documents"
    t.string "ecm_desc", limit: 191
    t.json "live_photos"
    t.json "documents"
    t.string "no", limit: 191
    t.bigint "sys_user_id", unsigned: true
    t.bigint "cl_online_id", unsigned: true
    t.bigint "display"
    t.string "source", limit: 191
    t.string "web_cover"
    t.integer "top_at"
    t.text "content"
    t.string "en_name", limit: 191
    t.index ["deleted_at"], name: "idx_cases_deleted_at"
  end

  create_table "cases_material", id: { type: :bigint, unsigned: true }, charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.datetime "deleted_at", precision: nil
    t.string "name", limit: 191
    t.string "no", limit: 191
    t.bigint "case_id", unsigned: true
    t.string "type_id", limit: 1, comment: "'材料类型1样品2产品'"
    t.bigint "obj_id", unsigned: true
    t.string "pics", limit: 191
    t.string "position", limit: 191
    t.string "color_system", limit: 191
    t.string "color_code", limit: 191
    t.string "spec_model", limit: 191
    t.string "technology", limit: 191
    t.string "manufactor", limit: 191
    t.string "remark", limit: 191
    t.bigint "manufacturer_id", unsigned: true
    t.bigint "surface_effect_id", unsigned: true
    t.bigint "color_system_id", unsigned: true
    t.bigint "material_id", unsigned: true
    t.bigint "sample_id", unsigned: true
    t.string "treatment_process", limit: 191
    t.boolean "is_main"
    t.string "effect_description", limit: 191
    t.bigint "case_delegate_record_id", comment: "案例id", unsigned: true
    t.bigint "application_site_id", unsigned: true
    t.index ["deleted_at"], name: "idx_cases_material_deleted_at"
  end

  create_table "cl_manufacturers", id: { type: :bigint, unsigned: true }, charset: "utf8", force: :cascade do |t|
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.datetime "deleted_at", precision: nil
    t.bigint "sys_user_id", unsigned: true
    t.bigint "manufacturer_id", unsigned: true
    t.string "name", limit: 191
    t.text "logo"
    t.text "main_material_remark"
    t.text "location"
    t.string "contact", limit: 191, comment: "'联系人'"
    t.string "address", limit: 191, comment: "'地址'"
    t.text "contact_information"
    t.text "website"
    t.text "materials"
    t.bigint "cl_online_id", unsigned: true
    t.json "performance_display"
    t.index ["deleted_at"], name: "idx_cl_manufacturers_deleted_at"
  end

  create_table "cl_material_infos", id: { type: :bigint, unsigned: true }, charset: "utf8", force: :cascade do |t|
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.datetime "deleted_at", precision: nil
    t.string "name", limit: 191
    t.text "remark"
    t.text "en_name"
    t.text "cover"
    t.bigint "material_id", unsigned: true
    t.text "technologies"
    t.text "scope"
    t.text "common_parameters"
    t.text "advantage"
    t.text "shortcoming"
    t.float "high_price", limit: 53
    t.float "low_price", limit: 53
    t.text "points"
    t.text "design_considerations"
    t.text "practice_details"
    t.text "source_file"
    t.bigint "cl_online_id", unsigned: true
    t.binary "practical_applications"
    t.text "qa_proposal"
    t.text "combination_proposal"
    t.binary "sku_picture_ids", size: :long
    t.binary "body", size: :long
    t.index ["deleted_at"], name: "idx_cl_material_infos_deleted_at"
  end

  create_table "cl_material_products", id: { type: :bigint, unsigned: true }, charset: "utf8", force: :cascade do |t|
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.datetime "deleted_at", precision: nil
    t.bigint "material_id", unsigned: true
    t.string "name", limit: 191
    t.text "remark"
    t.text "cover"
    t.bigint "color_system_id", unsigned: true
    t.text "color_system"
    t.text "section"
    t.text "surface_effects"
    t.text "practical_applications"
    t.text "origin"
    t.integer "is_common", limit: 1
    t.integer "is_customized", limit: 1
    t.text "customized"
    t.text "points"
    t.text "high_price"
    t.text "low_price"
    t.text "su_picture"
    t.text "practice_details"
    t.text "source_file"
    t.string "color_systems", limit: 191
    t.bigint "manufacturer_id", unsigned: true
    t.binary "body", size: :long
    t.index ["deleted_at"], name: "idx_cl_material_products_deleted_at"
    t.index ["material_id"], name: "idx_cl_material_products_material_id", unique: true
  end

  create_table "cl_materials", id: { type: :bigint, unsigned: true }, charset: "utf8", force: :cascade do |t|
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.datetime "deleted_at", precision: nil
    t.bigint "material_id", unsigned: true
    t.string "name", limit: 191
    t.string "en_name", limit: 191
    t.index ["deleted_at"], name: "idx_cl_materials_deleted_at"
  end

  create_table "color_systems", id: { type: :bigint, unsigned: true }, charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.datetime "deleted_at", precision: nil
    t.string "description", limit: 191
    t.index ["deleted_at"], name: "idx_color_systems_deleted_at"
    t.index ["deleted_at"], name: "idx_one_by_ones_deleted_at"
  end

  create_table "cool_website_categories", id: { type: :bigint, unsigned: true }, charset: "utf8", force: :cascade do |t|
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.datetime "deleted_at", precision: nil
    t.string "name", limit: 191
    t.bigint "order"
    t.index ["deleted_at"], name: "idx_cool_website_categories_deleted_at"
  end

  create_table "cool_websites", id: { type: :bigint, unsigned: true }, charset: "utf8", force: :cascade do |t|
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.datetime "deleted_at", precision: nil
    t.string "description", limit: 191
    t.boolean "display"
    t.string "icon", limit: 191
    t.string "name", limit: 191
    t.bigint "order"
    t.string "url", limit: 191
    t.bigint "cool_website_category_id", unsigned: true
    t.index ["deleted_at"], name: "idx_cool_websites_deleted_at"
  end

  create_table "cybros_tokens", id: { type: :bigint, unsigned: true }, charset: "utf8", force: :cascade do |t|
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.datetime "deleted_at", precision: nil
    t.string "app", limit: 191, comment: "应用"
    t.bigint "cybros_user_id", comment: "cybrosUserId用户ID"
    t.datetime "expired_at", precision: nil, comment: "过期时间"
    t.string "token", limit: 191
    t.index ["deleted_at"], name: "idx_cybros_tokens_deleted_at"
  end

  create_table "demand_replies", id: { type: :bigint, unsigned: true }, charset: "utf8", force: :cascade do |t|
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.datetime "deleted_at", precision: nil
    t.bigint "demand_id", unsigned: true
    t.string "content", limit: 191
    t.bigint "sys_user_id", unsigned: true
    t.index ["deleted_at"], name: "idx_demand_replies_deleted_at"
  end

  create_table "demands", id: { type: :bigint, unsigned: true }, charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.datetime "deleted_at", precision: nil
    t.bigint "demand_type"
    t.text "description", size: :long
    t.binary "references", size: :long, comment: "相关参考"
    t.string "ip", limit: 191
    t.string "user_name", limit: 191
    t.string "clerk_code", limit: 191
    t.bigint "material_id", unsigned: true
    t.datetime "resolved_at", precision: nil
    t.index ["deleted_at"], name: "idx_demands_deleted_at"
  end

  create_table "exa_customers", id: { type: :bigint, unsigned: true }, charset: "utf8mb4", collation: "utf8mb4_general_ci", force: :cascade do |t|
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.datetime "deleted_at", precision: nil
    t.string "customer_name", limit: 191, comment: "客户名"
    t.string "customer_phone_data", limit: 191, comment: "客户手机号"
    t.bigint "sys_user_id", comment: "管理ID", unsigned: true
    t.string "sys_user_authority_id", limit: 191, comment: "管理角色ID"
    t.index ["deleted_at"], name: "idx_exa_customers_deleted_at"
  end

  create_table "exa_file_chunks", id: { type: :bigint, unsigned: true }, charset: "utf8mb4", collation: "utf8mb4_general_ci", force: :cascade do |t|
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.datetime "deleted_at", precision: nil
    t.bigint "exa_file_id", unsigned: true
    t.bigint "file_chunk_number"
    t.string "file_chunk_path", limit: 191
    t.index ["deleted_at"], name: "idx_exa_file_chunks_deleted_at"
  end

  create_table "exa_file_upload_and_downloads", id: { type: :bigint, unsigned: true }, charset: "utf8mb4", collation: "utf8mb4_general_ci", force: :cascade do |t|
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.datetime "deleted_at", precision: nil
    t.string "name", limit: 191, comment: "文件名"
    t.string "url", limit: 191, comment: "文件地址"
    t.string "tag", limit: 191, comment: "文件标签"
    t.string "key", limit: 191, comment: "编号"
    t.bigint "size", comment: "'大小'"
    t.string "thumb", limit: 191, comment: "'封面'"
    t.index ["deleted_at"], name: "idx_exa_file_upload_and_downloads_deleted_at"
  end

  create_table "exa_files", id: { type: :bigint, unsigned: true }, charset: "utf8mb4", collation: "utf8mb4_general_ci", force: :cascade do |t|
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.datetime "deleted_at", precision: nil
    t.string "file_name", limit: 191
    t.string "file_md5", limit: 191
    t.string "file_path", limit: 191
    t.bigint "chunk_total"
    t.boolean "is_finish"
    t.index ["deleted_at"], name: "idx_exa_files_deleted_at"
  end

  create_table "exa_simple_uploaders", id: false, charset: "utf8mb4", collation: "utf8mb4_general_ci", force: :cascade do |t|
    t.string "chunk_number", limit: 191, comment: "当前切片标记"
    t.string "current_chunk_size", limit: 191, comment: "当前切片容量"
    t.string "current_chunk_path", limit: 191, comment: "切片本地路径"
    t.string "total_size", limit: 191, comment: "总容量"
    t.string "identifier", limit: 191, comment: "文件标识（md5）"
    t.string "filename", limit: 191, comment: "文件名"
    t.string "total_chunks", limit: 191, comment: "切片总数"
    t.boolean "is_done", comment: "是否上传完成"
    t.string "file_path", limit: 191, comment: "文件本地路径"
  end

  create_table "export_excels", id: { type: :bigint, unsigned: true }, charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.datetime "deleted_at", precision: nil
    t.string "token", limit: 191
    t.string "path", limit: 191
    t.string "status", limit: 191
    t.string "percent", limit: 191
    t.index ["deleted_at"], name: "idx_export_excels_deleted_at"
  end

  create_table "external_cases", id: { type: :bigint, unsigned: true }, charset: "utf8", force: :cascade do |t|
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.datetime "deleted_at", precision: nil
    t.bigint "external_user_id", unsigned: true
    t.bigint "case_delegate_record_id", unsigned: true
    t.string "status", limit: 191
    t.bigint "case_id", unsigned: true
    t.string "unpublish_text", limit: 191
    t.index ["deleted_at"], name: "idx_external_cases_deleted_at"
  end

  create_table "external_users", id: { type: :bigint, unsigned: true }, charset: "utf8", force: :cascade do |t|
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.datetime "deleted_at", precision: nil
    t.string "name", limit: 191
    t.string "mobile", limit: 191
    t.string "password", limit: 191
    t.index ["deleted_at"], name: "idx_external_users_deleted_at"
  end

  create_table "inspiration_pools", id: { type: :bigint, unsigned: true }, charset: "utf8", force: :cascade do |t|
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.datetime "deleted_at", precision: nil
    t.string "title", limit: 191
    t.string "img_src", limit: 191
    t.string "source", limit: 191
    t.bigint "picture_id"
    t.index ["deleted_at"], name: "idx_inspiration_pools_deleted_at"
  end

  create_table "inspirations", id: { type: :bigint, unsigned: true }, charset: "utf8", force: :cascade do |t|
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.datetime "deleted_at", precision: nil
    t.string "title", limit: 191
    t.string "description", limit: 191
    t.index ["deleted_at"], name: "idx_inspirations_deleted_at"
  end

  create_table "invitation_codes", id: { type: :bigint, unsigned: true }, charset: "utf8", force: :cascade do |t|
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.datetime "deleted_at", precision: nil
    t.string "code", limit: 191
    t.bigint "manufacturer_id", unsigned: true
    t.datetime "used_at", precision: nil
    t.index ["deleted_at"], name: "idx_invitation_codes_deleted_at"
  end

  create_table "jwt_blacklists", id: { type: :bigint, unsigned: true }, charset: "utf8mb4", collation: "utf8mb4_general_ci", force: :cascade do |t|
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.datetime "deleted_at", precision: nil
    t.text "jwt", comment: "jwt"
    t.index ["deleted_at"], name: "idx_jwt_blacklists_deleted_at"
  end

  create_table "lmkzscs", id: { type: :bigint, unsigned: true }, charset: "utf8", force: :cascade do |t|
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.datetime "deleted_at", precision: nil
    t.string "name", limit: 191
    t.string "path", limit: 191
    t.bigint "size"
    t.string "uploader", limit: 191
    t.string "clerk_code", limit: 191
    t.bigint "cybros_user_id", unsigned: true
    t.string "source", limit: 191
    t.string "jzw_path", limit: 191
    t.index ["deleted_at"], name: "idx_lmkzscs_deleted_at"
  end

  create_table "manufacturer_areas", primary_key: ["manufacturer_id", "area_id"], charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "manufacturer_id", null: false, unsigned: true
    t.bigint "area_id", null: false, unsigned: true
  end

  create_table "manufacturer_brands", primary_key: ["manufacturer_id", "brands_id"], charset: "utf8", force: :cascade do |t|
    t.bigint "manufacturer_id", null: false, unsigned: true
    t.bigint "brands_id", null: false, unsigned: true
  end

  create_table "manufacturer_contacts", id: { type: :bigint, unsigned: true }, charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.datetime "deleted_at", precision: nil
    t.string "name", limit: 191
    t.string "tel", limit: 191
    t.string "position", limit: 191
    t.string "source", limit: 191
    t.string "contact_type", limit: 191
    t.bigint "manufacturer_id", unsigned: true
    t.string "email", limit: 191
    t.bigint "manufacturer_record_id", unsigned: true
    t.bigint "type_id", unsigned: true
    t.bigint "manufacturer_history_id", unsigned: true
    t.index ["deleted_at"], name: "idx_manufacturer_contacts_deleted_at"
  end

  create_table "manufacturer_histories", id: { type: :bigint, unsigned: true }, charset: "utf8", force: :cascade do |t|
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.datetime "deleted_at", precision: nil
    t.bigint "manufacturer_id", unsigned: true
    t.bigint "sys_user_id", unsigned: true
    t.string "name", limit: 191
    t.string "logo", limit: 191
    t.string "main_materials", limit: 191
    t.text "cases", size: :long
    t.string "location", limit: 191
    t.string "contact", limit: 191
    t.string "email", limit: 191
    t.string "legal_email", limit: 191
    t.string "company_email", limit: 191
    t.string "staff_size", limit: 191
    t.string "company_at", limit: 191
    t.string "usc_code", limit: 191
    t.string "legal", limit: 191
    t.string "position", limit: 191
    t.string "registered_capital", limit: 191
    t.string "contact_information", limit: 191
    t.string "office_phone", limit: 191
    t.string "website", limit: 191
    t.string "address", limit: 191
    t.bigint "is_allow"
    t.bigint "cl_online_id", unsigned: true
    t.string "aq_online_id", limit: 191
    t.string "source", limit: 191
    t.string "brand_list", limit: 191
    t.text "performance_display"
    t.datetime "top_at", precision: nil
    t.integer "is_tho_co", limit: 1, unsigned: true
    t.bigint "display"
    t.bigint "external_user_id", unsigned: true
    t.string "status", limit: 191
    t.index ["deleted_at"], name: "idx_manufacturer_histories_deleted_at"
  end

  create_table "manufacturer_history_areas", primary_key: ["manufacturer_histories_id", "area_id"], charset: "utf8", force: :cascade do |t|
    t.bigint "manufacturer_histories_id", null: false, unsigned: true
    t.bigint "area_id", null: false, unsigned: true
  end

  create_table "manufacturer_history_brands", primary_key: ["manufacturer_histories_id", "brands_id"], charset: "utf8", force: :cascade do |t|
    t.bigint "manufacturer_histories_id", null: false, unsigned: true
    t.bigint "brands_id", null: false, unsigned: true
  end

  create_table "manufacturer_recommend_cases", id: { type: :bigint, unsigned: true }, charset: "utf8", force: :cascade do |t|
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.datetime "deleted_at", precision: nil
    t.string "pm_project_name", limit: 191
    t.string "name", limit: 191
    t.string "type_id", limit: 191
    t.bigint "manufacturer_recommend_id", unsigned: true
    t.string "no", limit: 191
    t.bigint "case_id", unsigned: true
    t.index ["deleted_at"], name: "idx_manufacturer_recommend_cases_deleted_at"
  end

  create_table "manufacturer_recommends", id: { type: :bigint, unsigned: true }, charset: "utf8", force: :cascade do |t|
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.datetime "deleted_at", precision: nil
    t.string "name", limit: 191, comment: "供应商名称"
    t.string "contact_name", limit: 191, comment: "联系人"
    t.bigint "material_id", comment: "供应商类型", unsigned: true
    t.string "contact_tel", limit: 191, comment: "联系电话"
    t.boolean "is_th_co", comment: "是否和天华合作过"
    t.string "reason", limit: 191, comment: "推荐理由"
    t.bigint "user_id", comment: "推荐用户ID", unsigned: true
    t.string "status", limit: 191, comment: "未审核:manufacturer_recommend_reviewing,审核通过:manufacturer_recommend_approved,审核不通过:manufacturer_recommend_rejected"
    t.bigint "invitation_code_id", unsigned: true
    t.index ["deleted_at"], name: "idx_manufacturer_recommends_deleted_at"
  end

  create_table "manufacturer_record_areas", primary_key: ["manufacturer_record_id", "area_id"], charset: "utf8", force: :cascade do |t|
    t.bigint "manufacturer_record_id", null: false, unsigned: true
    t.bigint "area_id", null: false, unsigned: true
  end

  create_table "manufacturer_record_cases", primary_key: ["manufacturer_record_id", "cases_id"], charset: "utf8", force: :cascade do |t|
    t.bigint "manufacturer_record_id", null: false, unsigned: true
    t.bigint "cases_id", null: false, unsigned: true
  end

  create_table "manufacturer_record_samples", id: { type: :bigint, unsigned: true }, charset: "utf8", force: :cascade do |t|
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.datetime "deleted_at", precision: nil
    t.bigint "manufacturer_record_id", unsigned: true
    t.boolean "is_pamphlet"
    t.string "pamphlet_image", limit: 191
    t.text "pamphlet_remark"
    t.boolean "is_small_sample"
    t.string "small_sample_image", limit: 191
    t.text "small_sample_remark"
    t.boolean "is_customized_sample"
    t.string "customized_sample_image", limit: 191
    t.text "customized_sample_remark"
    t.index ["deleted_at"], name: "idx_manufacturer_record_samples_deleted_at"
  end

  create_table "manufacturer_records", id: { type: :bigint, unsigned: true }, charset: "utf8", force: :cascade do |t|
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.datetime "deleted_at", precision: nil
    t.string "name", limit: 191
    t.string "logo", limit: 191
    t.string "usc_code", limit: 191
    t.string "company_at", limit: 191
    t.string "registered_capital", limit: 191
    t.string "staff_size", limit: 191
    t.string "original_addres", limit: 191
    t.string "company_tel", limit: 191
    t.string "company_email", limit: 191
    t.string "brands", limit: 191
    t.string "web_site", limit: 191
    t.bigint "external_user_id", unsigned: true
    t.string "main_material_remark", limit: 191
    t.bigint "is_allow"
    t.integer "is_tho_co", limit: 1, unsigned: true
    t.text "performance_display"
    t.string "status", limit: 191
    t.bigint "manufacturer_id", unsigned: true
    t.string "unpublish_text", limit: 191
    t.bigint "invitation_code_id", unsigned: true
    t.index ["deleted_at"], name: "idx_manufacturer_records_deleted_at"
  end

  create_table "manufacturers", id: { type: :bigint, unsigned: true }, charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.datetime "deleted_at", precision: nil
    t.string "name", limit: 191, comment: "产商名称"
    t.string "logo", limit: 191
    t.text "main_material_remark", comment: "主营描述"
    t.string "location", limit: 191, comment: "所在地"
    t.string "contact", limit: 191, comment: "联系人"
    t.string "contact_information", limit: 191, comment: "联系方式"
    t.string "address", comment: "联系人"
    t.string "website", comment: "网址"
    t.boolean "is_allow", comment: "是否提供样品"
    t.bigint "sys_user_id", unsigned: true
    t.bigint "cl_online_id", unsigned: true
    t.string "source", limit: 191
    t.string "main_materials", limit: 191
    t.string "registered_capital", limit: 191
    t.string "legal_email", limit: 191
    t.string "office_phone", limit: 191
    t.string "aq_online_id", limit: 191
    t.string "email", limit: 191
    t.string "legal", limit: 191
    t.string "position", limit: 191
    t.text "cases", size: :long
    t.datetime "top_at", precision: nil
    t.json "performance_display"
    t.integer "is_tho_co", limit: 1, default: 0
    t.bigint "display", comment: "'分类/产品id'"
    t.bigint "external_user_id", unsigned: true
    t.string "usc_code", limit: 191
    t.string "company_at", limit: 191
    t.string "company_email", limit: 191
    t.string "staff_size", limit: 191
    t.string "status", limit: 191
    t.string "brand_list", limit: 191
    t.index ["deleted_at"], name: "idx_manufacturers_deleted_at"
  end

  create_table "material_history_manufacturers", primary_key: ["manufacturer_histories_id", "material_id"], charset: "utf8", force: :cascade do |t|
    t.bigint "manufacturer_histories_id", null: false, unsigned: true
    t.bigint "material_id", null: false, unsigned: true
  end

  create_table "material_info_technology", primary_key: ["material_info_id", "technology_id"], charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "material_info_id", null: false, unsigned: true
    t.bigint "technology_id", null: false, unsigned: true
  end

  create_table "material_infos", id: { type: :bigint, unsigned: true }, charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.datetime "deleted_at", precision: nil
    t.bigint "material_id", unsigned: true
    t.string "scope", limit: 191, comment: "适用范围"
    t.text "common_parameters", comment: "适用范围"
    t.string "advantage", comment: "优点"
    t.string "shortcoming", comment: "缺点"
    t.string "high_price", limit: 191, comment: "价格高位"
    t.string "low_price", limit: 191, comment: "价格低位"
    t.text "points", comment: "安装施工要点"
    t.text "design_considerations", comment: "设计注意事项\r"
    t.json "practice_details", comment: "做法详图"
    t.json "source_file", comment: "做法详图源文件"
    t.binary "practical_applications"
    t.text "combination_proposal"
    t.binary "sku_picture_ids", size: :long
    t.text "qa_proposal"
    t.index ["deleted_at"], name: "idx_material_infos_deleted_at"
  end

  create_table "material_manufacturer_record", primary_key: ["manufacturer_record_id", "material_id"], charset: "utf8", force: :cascade do |t|
    t.bigint "manufacturer_record_id", null: false, unsigned: true
    t.bigint "material_id", null: false, unsigned: true
  end

  create_table "material_manufacturer_record_sample", primary_key: ["manufacturer_record_sample_id", "material_id"], charset: "utf8", force: :cascade do |t|
    t.bigint "manufacturer_record_sample_id", null: false, unsigned: true
    t.bigint "material_id", null: false, unsigned: true
  end

  create_table "material_manufacturers", primary_key: ["manufacturer_id", "material_id"], charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "manufacturer_id", null: false, unsigned: true
    t.bigint "material_id", null: false, unsigned: true
  end

  create_table "material_ones", primary_key: ["material_id", "one_by_one_id"], charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "material_id", null: false, unsigned: true
    t.bigint "one_by_one_id", null: false, unsigned: true
  end

  create_table "material_product_areas", primary_key: ["material_product_id", "area_id"], charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "material_product_id", null: false, unsigned: true
    t.bigint "area_id", null: false, unsigned: true
  end

  create_table "material_product_color_systems", primary_key: ["material_product_id", "color_systems_id"], charset: "utf8mb4", collation: "utf8mb4_bin", force: :cascade do |t|
    t.bigint "material_product_id", null: false, unsigned: true
    t.bigint "color_systems_id", null: false, unsigned: true
  end

  create_table "material_product_practical_applications", primary_key: ["material_product_id", "practical_applications_id"], charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "material_product_id", null: false, unsigned: true
    t.bigint "practical_applications_id", null: false, unsigned: true
  end

  create_table "material_product_sections", primary_key: ["material_product_id", "sections_id"], charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "material_product_id", null: false, unsigned: true
    t.bigint "sections_id", null: false, unsigned: true
    t.bigint "cl_material_product_id", unsigned: true
  end

  create_table "material_product_surface_effects", primary_key: ["material_product_id", "surface_effect_id"], charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "material_product_id", null: false, unsigned: true
    t.bigint "surface_effect_id", null: false, unsigned: true
  end

  create_table "material_products", id: { type: :bigint, unsigned: true }, charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.datetime "deleted_at", precision: nil
    t.bigint "material_id", comment: "材料ID", unsigned: true
    t.string "origin", limit: 191, comment: "产地"
    t.integer "is_common", limit: 1, comment: "常用产品"
    t.integer "is_customized", limit: 1, comment: "是否可定制效果"
    t.string "customized", limit: 191
    t.text "points", comment: "安装施工要点"
    t.string "high_price", limit: 191, comment: "价格区间 高位"
    t.string "low_price", limit: 191, comment: "价格区间 低位"
    t.text "su_picture", comment: "SU材质贴图"
    t.text "practice_details", comment: "做法详图"
    t.text "source_file", comment: "源文件"
    t.bigint "color_system_id", comment: "色系表", unsigned: true
    t.json "practical_applications"
    t.string "keyword", limit: 191
    t.index ["deleted_at"], name: "idx_material_products_deleted_at"
    t.index ["material_id"], name: "idx_material_products_material_id", unique: true
  end

  create_table "materials", id: { type: :bigint, unsigned: true }, charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.datetime "deleted_at", precision: nil
    t.bigint "user_id", unsigned: true
    t.string "name", limit: 191
    t.string "cover", limit: 191
    t.bigint "level"
    t.string "no", limit: 191
    t.string "en_name", limit: 191
    t.text "remark", size: :long
    t.bigint "parent_id", unsigned: true
    t.bigint "grandpa_id", unsigned: true
    t.bigint "sys_user_id", unsigned: true
    t.bigint "cl_online_id", unsigned: true
    t.string "source", limit: 191
    t.bigint "display"
    t.integer "update_status", default: 0
    t.bigint "aq_sample_id", unsigned: true
    t.bigint "zz_online_id", unsigned: true
    t.index ["deleted_at"], name: "idx_materials_deleted_at"
  end

  create_table "message_users", id: { type: :bigint, unsigned: true }, charset: "utf8", force: :cascade do |t|
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.datetime "deleted_at", precision: nil
    t.string "name", limit: 191
    t.bigint "user_id"
    t.index ["deleted_at"], name: "idx_message_users_deleted_at"
  end

  create_table "mr_case_live_photos", id: { type: :bigint, unsigned: true }, charset: "utf8", force: :cascade do |t|
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.datetime "deleted_at", precision: nil
    t.string "title", limit: 191
    t.bigint "manufacturer_recommend_case_id", unsigned: true
    t.string "path", limit: 191
    t.string "cover", limit: 191
    t.index ["deleted_at"], name: "idx_mr_case_live_photos_deleted_at"
  end

  create_table "news", id: { type: :bigint, unsigned: true }, charset: "utf8mb4", collation: "utf8mb4_bin", force: :cascade do |t|
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.datetime "deleted_at", precision: nil
    t.string "title", limit: 191
    t.string "subtitle", limit: 191
    t.string "mold_name", limit: 191
    t.string "cover", comment: "'图片'"
    t.text "url"
    t.bigint "cl_online_id", unsigned: true
    t.bigint "display"
    t.datetime "published_at", precision: nil
    t.bigint "manufacturer_id", unsigned: true
    t.bigint "material_id", unsigned: true
    t.integer "top", default: 0
    t.string "source", limit: 191
    t.boolean "is_official"
    t.index ["deleted_at"], name: "idx_news_deleted_at"
  end

  create_table "news_materials", primary_key: ["news_id", "material_id"], charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "news_id", null: false, unsigned: true
    t.bigint "material_id", null: false, unsigned: true
  end

  create_table "notifications", id: { type: :bigint, unsigned: true }, charset: "utf8", force: :cascade do |t|
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.datetime "deleted_at", precision: nil
    t.text "data", comment: "消息详细"
    t.bigint "notifiable_id", comment: "用户ID"
    t.string "notifiable_type", comment: "消息类型"
    t.timestamp "read_at", comment: "阅读日期"
    t.string "type_id", limit: 191
    t.binary "we_data", size: :long
    t.index ["deleted_at"], name: "idx_notifications_deleted_at"
  end

  create_table "one_by_ones", id: { type: :bigint, unsigned: true }, charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.datetime "deleted_at", precision: nil
    t.string "url", limit: 191
    t.bigint "app_id"
    t.string "one_type", limit: 191
    t.string "remark", limit: 191
    t.string "'url'", limit: 191
    t.index ["deleted_at"], name: "idx_one_by_ones_deleted_at"
  end

  create_table "pm_projects", id: { type: :bigint, unsigned: true }, charset: "utf8", force: :cascade do |t|
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.datetime "deleted_at", precision: nil
    t.string "project_name", limit: 191
    t.index ["deleted_at"], name: "idx_pm_projects_deleted_at"
  end

  create_table "practical_applications", id: { type: :bigint, unsigned: true }, charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.datetime "deleted_at", precision: nil
    t.string "description", limit: 191
    t.string "path", limit: 191
    t.index ["deleted_at"], name: "idx_practical_applications_deleted_at"
    t.index ["deleted_at"], name: "idx_sections_deleted_at"
    t.index ["deleted_at"], name: "idx_surface_effects_deleted_at"
  end

  create_table "quality_controls", id: { type: :bigint, unsigned: true }, charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.datetime "deleted_at", precision: nil
    t.bigint "type_id"
    t.string "cover", limit: 191
    t.string "title", limit: 191
    t.string "path", limit: 191
    t.bigint "material_id", unsigned: true
    t.index ["deleted_at"], name: "idx_quality_controls_deleted_at"
  end

  create_table "report_view_histories", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "controller_name"
    t.string "action_name"
    t.string "clerk_code"
    t.datetime "created_at", null: false
    t.text "request_path"
  end

  create_table "report_view_histories_copy1", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "controller_name"
    t.string "action_name"
    t.string "clerk_code"
    t.datetime "created_at", null: false
    t.text "request_path"
  end

  create_table "sample", id: { type: :bigint, unsigned: true }, charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.datetime "deleted_at", precision: nil
    t.string "no", limit: 191, comment: "样品编号"
    t.bigint "obj_id", comment: "样品编号", unsigned: true
    t.string "color_code", limit: 191, comment: "色号"
    t.string "spec_model", limit: 191, comment: "规格型号"
    t.string "pic", limit: 191, comment: "封面"
    t.string "position", limit: 191, comment: "位置"
    t.string "remark", limit: 500, comment: "'备注'"
    t.string "high_price", limit: 191, comment: "价格高"
    t.string "low_price", limit: 191, comment: "价格低"
    t.bigint "manufacturer_id", comment: "价格低", unsigned: true
    t.bigint "sys_user_id", unsigned: true
    t.bigint "surface_effect_id", unsigned: true
    t.string "source", limit: 191
    t.bigint "display", comment: "是否显示 1 or 0"
    t.bigint "color_system_id", comment: "色系", unsigned: true
    t.string "qr_code", limit: 191
    t.string "aq_online_id", limit: 191
    t.string "visual", limit: 191
    t.string "genus", limit: 191
    t.string "species", limit: 191
    t.bigint "brand_id", unsigned: true
    t.string "origin", limit: 191
    t.text "feature", size: :long
    t.text "technology", size: :long
    t.text "properties", size: :long
    t.text "application_site", size: :long
    t.text "model", size: :long
    t.string "price_unit", limit: 191
    t.bigint "sample_position_picture_id", unsigned: true
    t.string "status", limit: 191
    t.string "material_text", limit: 191
    t.string "aq_vein", limit: 191
    t.string "usage_state", limit: 191
    t.string "aq_name", limit: 191
    t.string "aq_sample_id"
    t.string "created_date", limit: 191
    t.index ["deleted_at"], name: "idx_sample_deleted_at"
  end

  create_table "sample_aq_info", id: { type: :bigint, unsigned: true }, charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.datetime "deleted_at", precision: nil
    t.bigint "sample_id", unsigned: true
    t.string "surface_effects", limit: 191
    t.string "color_code", limit: 191
    t.string "pic", limit: 191
    t.string "aq_name", limit: 191
    t.string "origin", limit: 191
    t.integer "is_common", limit: 1, unsigned: true
    t.string "usage_state", limit: 191
    t.binary "color_systems", size: :long
    t.float "price", limit: 53
    t.string "price_unit", limit: 191
    t.bigint "manufacturer_id", unsigned: true
    t.binary "practical_applications", size: :long
    t.binary "su_picture", size: :long
    t.bigint "level2_id", unsigned: true
    t.bigint "level1_id", unsigned: true
    t.index ["deleted_at"], name: "idx_sample_aq_info_deleted_at"
  end

  create_table "sample_color_systems", primary_key: ["sample_id", "color_systems_id"], charset: "utf8mb4", collation: "utf8mb4_bin", force: :cascade do |t|
    t.bigint "sample_id", null: false, unsigned: true
    t.bigint "color_systems_id", null: false, unsigned: true
  end

  create_table "sample_enclosures", id: { type: :bigint, unsigned: true }, charset: "utf8mb4", collation: "utf8mb4_bin", force: :cascade do |t|
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.datetime "deleted_at", precision: nil
    t.bigint "sample_id", unsigned: true
    t.string "path", limit: 191
    t.string "name", limit: 191
    t.index ["deleted_at"], name: "idx_sample_enclosures_deleted_at"
  end

  create_table "sample_examine_users", id: { type: :bigint, unsigned: true }, charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.datetime "deleted_at", precision: nil
    t.bigint "sample_examine_id", unsigned: true
    t.bigint "sample_id", unsigned: true
    t.bigint "sys_user_id", unsigned: true
    t.string "status", limit: 191
    t.string "other", limit: 191
    t.index ["deleted_at"], name: "idx_sample_examine_users_deleted_at"
  end

  create_table "sample_examines", id: { type: :bigint, unsigned: true }, charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.datetime "deleted_at", precision: nil
    t.bigint "sample_id", unsigned: true
    t.bigint "sys_user_id", unsigned: true
    t.string "status", limit: 191
    t.string "other", limit: 191
    t.index ["deleted_at"], name: "idx_sample_examines_deleted_at"
  end

  create_table "sample_position_pictures", id: { type: :bigint, unsigned: true }, charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.datetime "deleted_at", precision: nil
    t.string "name", limit: 191
    t.string "path", limit: 191
    t.index ["deleted_at"], name: "idx_sample_position_pictures_deleted_at"
  end

  create_table "sample_surface_effects", primary_key: ["sample_id", "surface_effect_id"], charset: "utf8mb4", collation: "utf8mb4_bin", force: :cascade do |t|
    t.bigint "sample_id", null: false, unsigned: true
    t.bigint "surface_effect_id", null: false, unsigned: true
  end

  create_table "sections", id: { type: :bigint, unsigned: true }, charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.datetime "deleted_at", precision: nil
    t.bigint "material_id"
    t.string "description", limit: 191
    t.string "path", limit: 191
    t.index ["deleted_at"], name: "idx_sections_deleted_at"
    t.index ["deleted_at"], name: "idx_surface_effects_deleted_at"
  end

  create_table "surface_effects", id: { type: :bigint, unsigned: true }, charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.datetime "deleted_at", precision: nil
    t.bigint "material_id"
    t.string "description", limit: 191
    t.string "path", limit: 191
    t.index ["deleted_at"], name: "idx_surface_effects_deleted_at"
  end

  create_table "sys_apis", id: { type: :bigint, unsigned: true }, charset: "utf8mb4", collation: "utf8mb4_general_ci", force: :cascade do |t|
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.datetime "deleted_at", precision: nil
    t.string "path", limit: 191, comment: "api路径"
    t.string "description", limit: 191, comment: "api中文描述"
    t.string "api_group", limit: 191, comment: "api组"
    t.string "method", limit: 191, default: "POST"
    t.index ["deleted_at"], name: "idx_sys_apis_deleted_at"
  end

  create_table "sys_authorities", primary_key: "authority_id", id: { type: :string, limit: 90, comment: "角色ID" }, charset: "utf8mb4", collation: "utf8mb4_general_ci", force: :cascade do |t|
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.datetime "deleted_at", precision: nil
    t.string "authority_name", limit: 191, comment: "角色名"
    t.string "parent_id", limit: 191, comment: "父角色ID"
    t.string "default_router", limit: 191, default: "dashboard", comment: "默认菜单"
    t.index ["authority_id"], name: "authority_id", unique: true
  end

  create_table "sys_authority_menus", primary_key: ["sys_base_menu_id", "sys_authority_authority_id"], charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "sys_base_menu_id", null: false, unsigned: true
    t.string "sys_authority_authority_id", limit: 90, null: false, comment: "角色ID"
  end

  create_table "sys_base_menu_parameters", id: { type: :bigint, unsigned: true }, charset: "utf8mb4", collation: "utf8mb4_general_ci", force: :cascade do |t|
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.datetime "deleted_at", precision: nil
    t.bigint "sys_base_menu_id", unsigned: true
    t.string "type", limit: 191, comment: "地址栏携带参数为params还是query"
    t.string "key", limit: 191, comment: "地址栏携带参数的key"
    t.string "value", limit: 191, comment: "地址栏携带参数的值"
    t.index ["deleted_at"], name: "idx_sys_base_menu_parameters_deleted_at"
  end

  create_table "sys_base_menus", id: { type: :bigint, unsigned: true }, charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.datetime "deleted_at", precision: nil
    t.bigint "menu_level", unsigned: true
    t.string "parent_id", limit: 191, comment: "父菜单ID"
    t.string "path", limit: 191, comment: "路由path"
    t.string "name", limit: 191, comment: "路由name"
    t.boolean "hidden", comment: "是否在列表隐藏"
    t.string "component", limit: 191, comment: "对应前端文件路径"
    t.bigint "sort", comment: "排序标记"
    t.boolean "keep_alive", comment: "附加属性"
    t.boolean "default_menu", comment: "附加属性"
    t.string "title", limit: 191, comment: "附加属性"
    t.string "icon", limit: 191, comment: "附加属性"
    t.boolean "close_tab", comment: "附加属性"
    t.index ["deleted_at"], name: "idx_sys_base_menus_deleted_at"
  end

  create_table "sys_data_authority_id", primary_key: ["sys_authority_authority_id", "data_authority_id_authority_id"], charset: "utf8mb4", collation: "utf8mb4_general_ci", force: :cascade do |t|
    t.string "sys_authority_authority_id", limit: 90, null: false, comment: "角色ID"
    t.string "data_authority_id_authority_id", limit: 90, null: false, comment: "角色ID"
  end

  create_table "sys_dictionaries", id: { type: :bigint, unsigned: true }, charset: "utf8mb4", collation: "utf8mb4_general_ci", force: :cascade do |t|
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.datetime "deleted_at", precision: nil
    t.string "name", limit: 191, comment: "字典名（中）"
    t.string "type", limit: 191, comment: "字典名（英）"
    t.boolean "status", comment: "状态"
    t.string "desc", limit: 191, comment: "描述"
    t.index ["deleted_at"], name: "idx_sys_dictionaries_deleted_at"
  end

  create_table "sys_dictionary_details", id: { type: :bigint, unsigned: true }, charset: "utf8mb4", collation: "utf8mb4_general_ci", force: :cascade do |t|
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.datetime "deleted_at", precision: nil
    t.string "label", limit: 191, comment: "展示值"
    t.bigint "value", comment: "字典值"
    t.boolean "status", comment: "启用状态"
    t.bigint "sort", comment: "排序标记"
    t.bigint "sys_dictionary_id", comment: "关联标记", unsigned: true
    t.index ["deleted_at"], name: "idx_sys_dictionary_details_deleted_at"
  end

  create_table "sys_operation_records", id: { type: :bigint, unsigned: true }, charset: "utf8mb4", collation: "utf8mb4_general_ci", force: :cascade do |t|
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.datetime "deleted_at", precision: nil
    t.string "ip", limit: 191, comment: "请求ip"
    t.string "method", limit: 191, comment: "请求方法"
    t.string "path", limit: 191, comment: "请求路径"
    t.bigint "status", comment: "请求状态"
    t.bigint "latency", comment: "延迟"
    t.string "agent", limit: 191, comment: "代理"
    t.string "error_message", limit: 191, comment: "错误信息"
    t.text "body", size: :long, comment: "请求Body"
    t.text "resp", size: :long, comment: "响应Body"
    t.bigint "user_id", comment: "用户id", unsigned: true
    t.index ["deleted_at"], name: "idx_sys_operation_records_deleted_at"
  end

  create_table "sys_users", id: { type: :bigint, unsigned: true }, charset: "utf8mb4", collation: "utf8mb4_general_ci", force: :cascade do |t|
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.datetime "deleted_at", precision: nil
    t.string "uuid", limit: 191, comment: "用户UUID"
    t.string "username", limit: 191, comment: "用户登录名"
    t.string "password", limit: 191, comment: "用户登录密码"
    t.string "nick_name", limit: 191, default: "系统用户", comment: "用户昵称"
    t.string "header_img", limit: 191, default: "http://qmplusimg.henrongyi.top/head.png", comment: "用户头像"
    t.string "authority_id", limit: 90, default: "888", comment: "用户角色ID"
    t.index ["deleted_at"], name: "idx_sys_users_deleted_at"
  end

  create_table "technology", id: { type: :bigint, unsigned: true }, charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.datetime "deleted_at", precision: nil
    t.bigint "material_id"
    t.string "description", limit: 191
    t.string "path", limit: 191
    t.index ["deleted_at"], name: "idx_surface_effects_deleted_at"
    t.index ["deleted_at"], name: "idx_technology_deleted_at"
  end

  create_table "th_demands", id: { type: :bigint, unsigned: true }, charset: "utf8mb4", collation: "utf8mb4_general_ci", force: :cascade do |t|
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.datetime "deleted_at", precision: nil
    t.bigint "user_id"
    t.string "demand_type", limit: 191
    t.string "no", limit: 191
    t.bigint "bid_id"
    t.index ["deleted_at"], name: "idx_th_demands_deleted_at"
  end

  create_table "th_users", id: { type: :bigint, unsigned: true }, charset: "utf8mb4", collation: "utf8mb4_general_ci", force: :cascade do |t|
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.datetime "deleted_at", precision: nil
    t.string "name", limit: 191
    t.string "email", limit: 191
    t.index ["deleted_at"], name: "idx_th_users_deleted_at"
  end

  create_table "tops", id: { type: :bigint, unsigned: true }, charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.datetime "deleted_at", precision: nil
    t.string "top_model", limit: 191
    t.string "cover", limit: 191
    t.string "url", limit: 191
    t.string "name", limit: 191
    t.integer "top_sort", limit: 1, unsigned: true
    t.bigint "material_id", unsigned: true
    t.bigint "case_id", unsigned: true
    t.index ["deleted_at"], name: "idx_tops_deleted_at"
  end

  create_table "user_languages", primary_key: ["material_id", "one_by_one_id"], charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "material_id", null: false, unsigned: true
    t.bigint "one_by_one_id", null: false, unsigned: true
  end

  create_table "users", id: { type: :bigint, unsigned: true }, charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.datetime "deleted_at", precision: nil
    t.string "clerk_code", limit: 191
    t.string "name", limit: 191
    t.string "dep_name", limit: 191
    t.string "company_name", limit: 191
    t.string "post_name", limit: 191
    t.string "email", limit: 191
    t.bigint "is_out"
    t.index ["deleted_at"], name: "idx_users_deleted_at"
  end

end
