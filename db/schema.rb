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

ActiveRecord::Schema.define(version: 2022_01_04_085825) do

  create_table "aq_manufacturers", id: { type: :bigint, unsigned: true }, charset: "utf8mb3", force: :cascade do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "deleted_at"
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

  create_table "areas", id: { type: :bigint, unsigned: true }, charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "deleted_at"
    t.string "title", limit: 191
    t.string "letter", limit: 191
    t.bigint "area_id", unsigned: true
    t.bigint "sort"
    t.bigint "page_int"
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

  create_table "brands", id: { type: :bigint, unsigned: true }, charset: "utf8mb3", force: :cascade do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "deleted_at"
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

  create_table "case_material_color_systems", primary_key: ["cases_material_id", "color_systems_id"], charset: "utf8mb4", collation: "utf8mb4_bin", force: :cascade do |t|
    t.bigint "cases_material_id", null: false, unsigned: true
    t.bigint "color_systems_id", null: false, unsigned: true
  end

  create_table "case_material_surface_effects", primary_key: ["cases_material_id", "surface_effect_id"], charset: "utf8mb4", collation: "utf8mb4_bin", force: :cascade do |t|
    t.bigint "cases_material_id", null: false, unsigned: true
    t.bigint "surface_effect_id", null: false, unsigned: true
  end

  create_table "cases", id: { type: :bigint, unsigned: true }, charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "deleted_at"
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
    t.bigint "area_id", unsigned: true
    t.string "jzw_url", limit: 191
    t.string "th_no", limit: 191
    t.boolean "is_jzw"
    t.bigint "zz_online_id", unsigned: true
    t.index ["deleted_at"], name: "idx_cases_deleted_at"
  end

  create_table "cases_copy1", id: { type: :bigint, unsigned: true }, charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "deleted_at"
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
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "deleted_at"
    t.string "name", limit: 191
    t.string "no", limit: 191
    t.bigint "case_id", unsigned: true
    t.string "type_id", limit: 191
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
    t.index ["deleted_at"], name: "idx_cases_material_deleted_at"
  end

  create_table "cl_manufacturers", id: { type: :bigint, unsigned: true }, charset: "utf8mb3", force: :cascade do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "deleted_at"
    t.bigint "sys_user_id", unsigned: true
    t.bigint "manufacturer_id", unsigned: true
    t.string "name", limit: 191
    t.text "logo"
    t.text "main_material_remark"
    t.text "location"
    t.text "contact"
    t.text "address"
    t.text "contact_information"
    t.text "website"
    t.text "materials"
    t.bigint "cl_online_id", unsigned: true
    t.json "performance_display"
    t.index ["deleted_at"], name: "idx_cl_manufacturers_deleted_at"
  end

  create_table "cl_material_infos", id: { type: :bigint, unsigned: true }, charset: "utf8mb3", force: :cascade do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "deleted_at"
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
    t.index ["deleted_at"], name: "idx_cl_material_infos_deleted_at"
  end

  create_table "cl_material_products", id: { type: :bigint, unsigned: true }, charset: "utf8mb3", force: :cascade do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "deleted_at"
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
    t.index ["deleted_at"], name: "idx_cl_material_products_deleted_at"
    t.index ["material_id"], name: "idx_cl_material_products_material_id", unique: true
  end

  create_table "cl_materials", id: { type: :bigint, unsigned: true }, charset: "utf8mb3", force: :cascade do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "deleted_at"
    t.bigint "material_id", unsigned: true
    t.string "name", limit: 191
    t.string "en_name", limit: 191
    t.index ["deleted_at"], name: "idx_cl_materials_deleted_at"
  end

  create_table "color_systems", id: { type: :bigint, unsigned: true }, charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "deleted_at"
    t.string "description", limit: 191
    t.index ["deleted_at"], name: "idx_color_systems_deleted_at"
    t.index ["deleted_at"], name: "idx_one_by_ones_deleted_at"
  end

  create_table "cool_website_categories", id: { type: :bigint, unsigned: true }, charset: "utf8mb3", force: :cascade do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "deleted_at"
    t.string "name", limit: 191
    t.bigint "order"
    t.index ["deleted_at"], name: "idx_cool_website_categories_deleted_at"
  end

  create_table "cool_websites", id: { type: :bigint, unsigned: true }, charset: "utf8mb3", force: :cascade do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "deleted_at"
    t.string "description", limit: 191
    t.boolean "display"
    t.string "icon", limit: 191
    t.string "name", limit: 191
    t.bigint "order"
    t.string "url", limit: 191
    t.bigint "cool_website_category_id", unsigned: true
    t.index ["deleted_at"], name: "idx_cool_websites_deleted_at"
  end

  create_table "demands", id: { type: :bigint, unsigned: true }, charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "deleted_at"
    t.bigint "demand_type"
    t.string "description", limit: 191
    t.string "references", limit: 191
    t.string "ip", limit: 191
    t.string "user_name", limit: 191
    t.string "clerk_code", limit: 191
    t.bigint "material_id", unsigned: true
    t.index ["deleted_at"], name: "idx_demands_deleted_at"
  end

  create_table "exa_customers", id: { type: :bigint, unsigned: true }, charset: "utf8mb4", collation: "utf8mb4_general_ci", force: :cascade do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "deleted_at"
    t.string "customer_name", limit: 191, comment: "客户名"
    t.string "customer_phone_data", limit: 191, comment: "客户手机号"
    t.bigint "sys_user_id", comment: "管理ID", unsigned: true
    t.string "sys_user_authority_id", limit: 191, comment: "管理角色ID"
    t.index ["deleted_at"], name: "idx_exa_customers_deleted_at"
  end

  create_table "exa_file_chunks", id: { type: :bigint, unsigned: true }, charset: "utf8mb4", collation: "utf8mb4_general_ci", force: :cascade do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "deleted_at"
    t.bigint "exa_file_id", unsigned: true
    t.bigint "file_chunk_number"
    t.string "file_chunk_path", limit: 191
    t.index ["deleted_at"], name: "idx_exa_file_chunks_deleted_at"
  end

  create_table "exa_file_upload_and_downloads", id: { type: :bigint, unsigned: true }, charset: "utf8mb4", collation: "utf8mb4_general_ci", force: :cascade do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "deleted_at"
    t.string "name", limit: 191, comment: "文件名"
    t.string "url", limit: 191, comment: "文件地址"
    t.string "tag", limit: 191, comment: "文件标签"
    t.string "key", limit: 191, comment: "编号"
    t.index ["deleted_at"], name: "idx_exa_file_upload_and_downloads_deleted_at"
  end

  create_table "exa_files", id: { type: :bigint, unsigned: true }, charset: "utf8mb4", collation: "utf8mb4_general_ci", force: :cascade do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "deleted_at"
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

  create_table "inspiration_pools", id: { type: :bigint, unsigned: true }, charset: "utf8mb3", force: :cascade do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "deleted_at"
    t.string "title", limit: 191
    t.string "img_src", limit: 191
    t.string "source", limit: 191
    t.bigint "picture_id"
    t.index ["deleted_at"], name: "idx_inspiration_pools_deleted_at"
  end

  create_table "inspirations", id: { type: :bigint, unsigned: true }, charset: "utf8mb3", force: :cascade do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "deleted_at"
    t.string "title", limit: 191
    t.string "description", limit: 191
    t.index ["deleted_at"], name: "idx_inspirations_deleted_at"
  end

  create_table "jwt_blacklists", id: { type: :bigint, unsigned: true }, charset: "utf8mb4", collation: "utf8mb4_general_ci", force: :cascade do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "deleted_at"
    t.text "jwt", comment: "jwt"
    t.index ["deleted_at"], name: "idx_jwt_blacklists_deleted_at"
  end

  create_table "manufacturer_areas", primary_key: ["manufacturer_id", "area_id"], charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "manufacturer_id", null: false, unsigned: true
    t.bigint "area_id", null: false, unsigned: true
  end

  create_table "manufacturer_brands", primary_key: ["manufacturer_id", "brands_id"], charset: "utf8mb3", force: :cascade do |t|
    t.bigint "manufacturer_id", null: false, unsigned: true
    t.bigint "brands_id", null: false, unsigned: true
  end

  create_table "manufacturers", id: { type: :bigint, unsigned: true }, charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "deleted_at"
    t.string "name", limit: 191, comment: "产商名称"
    t.text "logo", comment: "产商logo"
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
    t.datetime "top_at"
    t.json "performance_display"
    t.integer "is_tho_co", limit: 1, default: 0
    t.index ["deleted_at"], name: "idx_manufacturers_deleted_at"
  end

  create_table "material_info_technology", primary_key: ["material_info_id", "technology_id"], charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "material_info_id", null: false, unsigned: true
    t.bigint "technology_id", null: false, unsigned: true
  end

  create_table "material_infos", id: { type: :bigint, unsigned: true }, charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "deleted_at"
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
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "deleted_at"
    t.bigint "material_id", comment: "材料ID", unsigned: true
    t.string "origin", limit: 191, comment: "产地"
    t.integer "is_common", limit: 1, comment: "常用产品"
    t.integer "is_customized", limit: 1, comment: "是否可定制效果"
    t.text "customized", comment: "效果描述"
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
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "deleted_at"
    t.bigint "user_id", unsigned: true
    t.string "name", limit: 191
    t.text "cover"
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

  create_table "news", id: { type: :bigint, unsigned: true }, charset: "utf8mb4", collation: "utf8mb4_bin", force: :cascade do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "deleted_at"
    t.string "title", limit: 191
    t.string "subtitle", limit: 191
    t.string "mold_name", limit: 191
    t.string "cover", limit: 191
    t.text "url"
    t.bigint "cl_online_id", unsigned: true
    t.bigint "display"
    t.datetime "published_at"
    t.bigint "manufacturer_id", unsigned: true
    t.bigint "material_id", unsigned: true
    t.integer "top", default: 0
    t.index ["deleted_at"], name: "idx_news_deleted_at"
  end

  create_table "news_materials", primary_key: ["news_id", "material_id"], charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "news_id", null: false, unsigned: true
    t.bigint "material_id", null: false, unsigned: true
  end

  create_table "one_by_ones", id: { type: :bigint, unsigned: true }, charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "deleted_at"
    t.string "url", limit: 191
    t.bigint "app_id"
    t.string "one_type", limit: 191
    t.string "remark", limit: 191
    t.index ["deleted_at"], name: "idx_one_by_ones_deleted_at"
  end

  create_table "practical_applications", id: { type: :bigint, unsigned: true }, charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "deleted_at"
    t.string "description", limit: 191
    t.string "path", limit: 191
    t.index ["deleted_at"], name: "idx_practical_applications_deleted_at"
    t.index ["deleted_at"], name: "idx_sections_deleted_at"
    t.index ["deleted_at"], name: "idx_surface_effects_deleted_at"
  end

  create_table "quality_controls", id: { type: :bigint, unsigned: true }, charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "deleted_at"
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
    t.datetime "created_at", precision: 6, null: false
    t.text "request_path"
  end

  create_table "sample", id: { type: :bigint, unsigned: true }, charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "deleted_at"
    t.string "no", limit: 191, comment: "样品编号"
    t.bigint "obj_id", comment: "样品编号", unsigned: true
    t.string "color_code", limit: 191, comment: "色号"
    t.string "spec_model", limit: 191, comment: "规格型号"
    t.string "pic", limit: 191, comment: "封面"
    t.string "position", limit: 191, comment: "位置"
    t.string "remark", limit: 191, comment: "备注"
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
    t.string "material_text"
    t.string "aq_vein"
    t.string "usage_state", limit: 191
    t.string "aq_name"
    t.string "aq_sample_id"
    t.index ["deleted_at"], name: "idx_sample_deleted_at"
  end

  create_table "sample_aq_info", id: { type: :bigint, unsigned: true }, charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "deleted_at"
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
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "deleted_at"
    t.bigint "sample_id", unsigned: true
    t.string "path", limit: 191
    t.string "name", limit: 191
    t.index ["deleted_at"], name: "idx_sample_enclosures_deleted_at"
  end

  create_table "sample_examine_users", id: { type: :bigint, unsigned: true }, charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "deleted_at"
    t.bigint "sample_examine_id", unsigned: true
    t.bigint "sample_id", unsigned: true
    t.bigint "sys_user_id", unsigned: true
    t.string "status", limit: 191
    t.string "other", limit: 191
    t.index ["deleted_at"], name: "idx_sample_examine_users_deleted_at"
  end

  create_table "sample_examines", id: { type: :bigint, unsigned: true }, charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "deleted_at"
    t.bigint "sample_id", unsigned: true
    t.bigint "sys_user_id", unsigned: true
    t.string "status", limit: 191
    t.string "other", limit: 191
    t.index ["deleted_at"], name: "idx_sample_examines_deleted_at"
  end

  create_table "sample_position_pictures", id: { type: :bigint, unsigned: true }, charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "deleted_at"
    t.string "name", limit: 191
    t.string "path", limit: 191
    t.index ["deleted_at"], name: "idx_sample_position_pictures_deleted_at"
  end

  create_table "sample_surface_effects", primary_key: ["sample_id", "surface_effect_id"], charset: "utf8mb4", collation: "utf8mb4_bin", force: :cascade do |t|
    t.bigint "sample_id", null: false, unsigned: true
    t.bigint "surface_effect_id", null: false, unsigned: true
  end

  create_table "sections", id: { type: :bigint, unsigned: true }, charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "deleted_at"
    t.bigint "material_id"
    t.string "description", limit: 191
    t.string "path", limit: 191
    t.index ["deleted_at"], name: "idx_sections_deleted_at"
    t.index ["deleted_at"], name: "idx_surface_effects_deleted_at"
  end

  create_table "surface_effects", id: { type: :bigint, unsigned: true }, charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "deleted_at"
    t.bigint "material_id"
    t.string "description", limit: 191
    t.string "path", limit: 191
    t.index ["deleted_at"], name: "idx_surface_effects_deleted_at"
  end

  create_table "sys_apis", id: { type: :bigint, unsigned: true }, charset: "utf8mb4", collation: "utf8mb4_general_ci", force: :cascade do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "deleted_at"
    t.string "path", limit: 191, comment: "api路径"
    t.string "description", limit: 191, comment: "api中文描述"
    t.string "api_group", limit: 191, comment: "api组"
    t.string "method", limit: 191, default: "POST"
    t.index ["deleted_at"], name: "idx_sys_apis_deleted_at"
  end

  create_table "sys_authorities", primary_key: "authority_id", id: { type: :string, limit: 90, comment: "角色ID" }, charset: "utf8mb4", collation: "utf8mb4_general_ci", force: :cascade do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "deleted_at"
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
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "deleted_at"
    t.bigint "sys_base_menu_id", unsigned: true
    t.string "type", limit: 191, comment: "地址栏携带参数为params还是query"
    t.string "key", limit: 191, comment: "地址栏携带参数的key"
    t.string "value", limit: 191, comment: "地址栏携带参数的值"
    t.index ["deleted_at"], name: "idx_sys_base_menu_parameters_deleted_at"
  end

  create_table "sys_base_menus", id: { type: :bigint, unsigned: true }, charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "deleted_at"
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
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "deleted_at"
    t.string "name", limit: 191, comment: "字典名（中）"
    t.string "type", limit: 191, comment: "字典名（英）"
    t.boolean "status", comment: "状态"
    t.string "desc", limit: 191, comment: "描述"
    t.index ["deleted_at"], name: "idx_sys_dictionaries_deleted_at"
  end

  create_table "sys_dictionary_details", id: { type: :bigint, unsigned: true }, charset: "utf8mb4", collation: "utf8mb4_general_ci", force: :cascade do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "deleted_at"
    t.string "label", limit: 191, comment: "展示值"
    t.bigint "value", comment: "字典值"
    t.boolean "status", comment: "启用状态"
    t.bigint "sort", comment: "排序标记"
    t.bigint "sys_dictionary_id", comment: "关联标记", unsigned: true
    t.index ["deleted_at"], name: "idx_sys_dictionary_details_deleted_at"
  end

  create_table "sys_operation_records", id: { type: :bigint, unsigned: true }, charset: "utf8mb4", collation: "utf8mb4_general_ci", force: :cascade do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "deleted_at"
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
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "deleted_at"
    t.string "uuid", limit: 191, comment: "用户UUID"
    t.string "username", limit: 191, comment: "用户登录名"
    t.string "password", limit: 191, comment: "用户登录密码"
    t.string "nick_name", limit: 191, default: "系统用户", comment: "用户昵称"
    t.string "header_img", limit: 191, default: "http://qmplusimg.henrongyi.top/head.png", comment: "用户头像"
    t.string "authority_id", limit: 90, default: "888", comment: "用户角色ID"
    t.index ["deleted_at"], name: "idx_sys_users_deleted_at"
  end

  create_table "technology", id: { type: :bigint, unsigned: true }, charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "deleted_at"
    t.bigint "material_id"
    t.string "description", limit: 191
    t.string "path", limit: 191
    t.index ["deleted_at"], name: "idx_surface_effects_deleted_at"
    t.index ["deleted_at"], name: "idx_technology_deleted_at"
  end

  create_table "th_demands", id: { type: :bigint, unsigned: true }, charset: "utf8mb4", collation: "utf8mb4_general_ci", force: :cascade do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "deleted_at"
    t.bigint "user_id"
    t.string "demand_type", limit: 191
    t.string "no", limit: 191
    t.bigint "bid_id"
    t.index ["deleted_at"], name: "idx_th_demands_deleted_at"
  end

  create_table "th_users", id: { type: :bigint, unsigned: true }, charset: "utf8mb4", collation: "utf8mb4_general_ci", force: :cascade do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "deleted_at"
    t.string "name", limit: 191
    t.string "email", limit: 191
    t.index ["deleted_at"], name: "idx_th_users_deleted_at"
  end

  create_table "tops", id: { type: :bigint, unsigned: true }, charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "deleted_at"
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

end
