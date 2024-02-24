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

ActiveRecord::Schema[7.0].define(version: 2022_12_31_003438) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "action_mailbox_inbound_emails", force: :cascade do |t|
    t.integer "status", default: 0, null: false
    t.string "message_id", null: false
    t.string "message_checksum", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["message_id", "message_checksum"], name: "index_action_mailbox_inbound_emails_uniqueness", unique: true
  end

  create_table "action_text_rich_texts", force: :cascade do |t|
    t.string "name", null: false
    t.text "body"
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["record_type", "record_id", "name"], name: "index_action_text_rich_texts_uniqueness", unique: true
  end

  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", precision: nil, null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.bigint "byte_size", null: false
    t.string "checksum", null: false
    t.datetime "created_at", precision: nil, null: false
    t.string "service_name", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "blog_post_taggings", id: :serial, force: :cascade do |t|
    t.integer "blog_post_id", null: false
    t.integer "tag_id", null: false
  end

  create_table "blog_post_tags", id: :serial, force: :cascade do |t|
    t.string "name", null: false
  end

  create_table "comfy_blog_comments", id: :serial, force: :cascade do |t|
    t.integer "post_id", null: false
    t.string "author", null: false
    t.string "email", null: false
    t.text "content"
    t.boolean "is_published", default: false, null: false
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.index ["post_id", "created_at"], name: "index_comfy_blog_comments_on_post_id_and_created_at"
    t.index ["post_id", "is_published", "created_at"], name: "index_blog_comments_on_post_published_created"
  end

  create_table "comfy_blog_posts", id: :serial, force: :cascade do |t|
    t.integer "blog_id", null: false
    t.string "title", null: false
    t.string "slug", null: false
    t.text "content"
    t.string "excerpt", limit: 1024
    t.string "author"
    t.integer "year", null: false
    t.integer "month", limit: 2, null: false
    t.boolean "is_published", default: true, null: false
    t.datetime "published_at", precision: nil, null: false
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.index ["created_at"], name: "index_comfy_blog_posts_on_created_at"
    t.index ["is_published", "created_at"], name: "index_comfy_blog_posts_on_is_published_and_created_at"
    t.index ["is_published", "year", "month", "slug"], name: "index_blog_posts_on_published_year_month_slug"
  end

  create_table "comfy_blogs", id: :serial, force: :cascade do |t|
    t.integer "site_id", null: false
    t.string "label", null: false
    t.string "identifier", null: false
    t.string "app_layout", default: "application", null: false
    t.string "path"
    t.text "description"
    t.index ["identifier"], name: "index_comfy_blogs_on_identifier"
    t.index ["site_id", "path"], name: "index_comfy_blogs_on_site_id_and_path"
  end

  create_table "comfy_cms_blocks", id: :serial, force: :cascade do |t|
    t.string "identifier", null: false
    t.text "content"
    t.integer "blockable_id"
    t.string "blockable_type"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.index ["blockable_id", "blockable_type"], name: "index_comfy_cms_blocks_on_blockable_id_and_blockable_type"
    t.index ["identifier"], name: "index_comfy_cms_blocks_on_identifier"
  end

  create_table "comfy_cms_categories", id: :serial, force: :cascade do |t|
    t.integer "site_id", null: false
    t.string "label", null: false
    t.string "categorized_type", null: false
    t.index ["site_id", "categorized_type", "label"], name: "index_cms_categories_on_site_id_and_cat_type_and_label", unique: true
  end

  create_table "comfy_cms_categorizations", id: :serial, force: :cascade do |t|
    t.integer "category_id", null: false
    t.string "categorized_type", null: false
    t.integer "categorized_id", null: false
    t.index ["category_id", "categorized_type", "categorized_id"], name: "index_cms_categorizations_on_cat_id_and_catd_type_and_catd_id", unique: true
  end

  create_table "comfy_cms_files", id: :serial, force: :cascade do |t|
    t.integer "site_id", null: false
    t.integer "block_id"
    t.string "label", null: false
    t.string "file_file_name", null: false
    t.string "file_content_type", null: false
    t.integer "file_file_size", null: false
    t.string "description", limit: 2048
    t.integer "position", default: 0, null: false
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.index ["site_id", "block_id"], name: "index_comfy_cms_files_on_site_id_and_block_id"
    t.index ["site_id", "file_file_name"], name: "index_comfy_cms_files_on_site_id_and_file_file_name"
    t.index ["site_id", "label"], name: "index_comfy_cms_files_on_site_id_and_label"
    t.index ["site_id", "position"], name: "index_comfy_cms_files_on_site_id_and_position"
  end

  create_table "comfy_cms_layouts", id: :serial, force: :cascade do |t|
    t.integer "site_id", null: false
    t.integer "parent_id"
    t.string "app_layout"
    t.string "label", null: false
    t.string "identifier", null: false
    t.text "content"
    t.text "css"
    t.text "js"
    t.integer "position", default: 0, null: false
    t.boolean "is_shared", default: false, null: false
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.index ["parent_id", "position"], name: "index_comfy_cms_layouts_on_parent_id_and_position"
    t.index ["site_id", "identifier"], name: "index_comfy_cms_layouts_on_site_id_and_identifier", unique: true
  end

  create_table "comfy_cms_pages", id: :serial, force: :cascade do |t|
    t.integer "site_id", null: false
    t.integer "layout_id"
    t.integer "parent_id"
    t.integer "target_page_id"
    t.string "label", null: false
    t.string "slug"
    t.string "full_path", null: false
    t.text "content_cache"
    t.integer "position", default: 0, null: false
    t.integer "children_count", default: 0, null: false
    t.boolean "is_published", default: true, null: false
    t.boolean "is_shared", default: false, null: false
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.index ["parent_id", "position"], name: "index_comfy_cms_pages_on_parent_id_and_position"
    t.index ["site_id", "full_path"], name: "index_comfy_cms_pages_on_site_id_and_full_path"
  end

  create_table "comfy_cms_revisions", id: :serial, force: :cascade do |t|
    t.string "record_type", null: false
    t.integer "record_id", null: false
    t.text "data"
    t.datetime "created_at", precision: nil
    t.index ["record_type", "record_id", "created_at"], name: "index_cms_revisions_on_rtype_and_rid_and_created_at"
  end

  create_table "comfy_cms_sites", id: :serial, force: :cascade do |t|
    t.string "label", null: false
    t.string "identifier", null: false
    t.string "hostname", null: false
    t.string "path"
    t.string "locale", default: "en", null: false
    t.boolean "is_mirrored", default: false, null: false
    t.index ["hostname"], name: "index_comfy_cms_sites_on_hostname"
    t.index ["is_mirrored"], name: "index_comfy_cms_sites_on_is_mirrored"
  end

  create_table "comfy_cms_snippets", id: :serial, force: :cascade do |t|
    t.integer "site_id", null: false
    t.string "label", null: false
    t.string "identifier", null: false
    t.text "content"
    t.integer "position", default: 0, null: false
    t.boolean "is_shared", default: false, null: false
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.index ["site_id", "identifier"], name: "index_comfy_cms_snippets_on_site_id_and_identifier", unique: true
    t.index ["site_id", "position"], name: "index_comfy_cms_snippets_on_site_id_and_position"
  end

  create_table "families", id: :serial, force: :cascade do |t|
    t.string "mother_name"
    t.string "mother_email"
    t.string "mother_phone"
    t.integer "income"
    t.text "comment"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.string "father_name"
    t.string "father_email"
    t.string "father_phone"
    t.boolean "parent_at_home"
    t.boolean "is_lead"
    t.text "lead_comments"
  end

  create_table "gallery_galleries", id: :serial, force: :cascade do |t|
    t.string "title", null: false
    t.string "identifier", null: false
    t.text "description"
    t.integer "full_width", default: 1024
    t.integer "full_height", default: 768
    t.boolean "force_ratio_full", default: false, null: false
    t.integer "thumb_width", default: 150
    t.integer "thumb_height", default: 150
    t.boolean "force_ratio_thumb", default: true, null: false
    t.string "layout"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.index ["identifier"], name: "index_gallery_galleries_on_identifier", unique: true
  end

  create_table "gallery_photos", id: :serial, force: :cascade do |t|
    t.integer "gallery_id", null: false
    t.string "title"
    t.text "description"
    t.string "image_file_name"
    t.string "image_content_type"
    t.integer "image_file_size"
    t.integer "position", default: 0, null: false
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.text "url"
    t.text "tags"
    t.index ["gallery_id", "position"], name: "index_gallery_photos_on_gallery_id_and_position"
  end

  create_table "integrations_stripe_installations", force: :cascade do |t|
    t.bigint "team_id", null: false
    t.bigint "oauth_stripe_account_id", null: false
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["oauth_stripe_account_id"], name: "index_stripe_installations_on_stripe_account_id"
    t.index ["team_id"], name: "index_integrations_stripe_installations_on_team_id"
  end

  create_table "invitations", id: :serial, force: :cascade do |t|
    t.string "email"
    t.string "uuid"
    t.integer "from_membership_id"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.integer "team_id"
    t.index ["team_id"], name: "index_invitations_on_team_id"
  end

  create_table "invoices", id: :serial, force: :cascade do |t|
    t.date "invoice_date"
    t.date "due_date"
    t.float "amount"
    t.float "amount_due"
    t.integer "family_id"
    t.string "ocr"
    t.boolean "canceled"
    t.date "fee_month"
    t.date "last_reminded"
    t.date "last_alert"
    t.date "payed_on"
    t.index ["family_id"], name: "index_invoices_on_family_id"
  end

  create_table "kids", id: :serial, force: :cascade do |t|
    t.string "full_name"
    t.string "ssn"
    t.date "start_date"
    t.date "end_date"
    t.text "comment"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.integer "family_id"
    t.integer "birth_order"
    t.boolean "pending"
    t.boolean "is_lead"
    t.index ["family_id"], name: "index_kids_on_family_id"
  end

  create_table "memberships", id: :serial, force: :cascade do |t|
    t.integer "user_id"
    t.integer "team_id"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.bigint "invitation_id"
    t.string "user_first_name"
    t.string "user_last_name"
    t.string "user_profile_photo_id"
    t.string "user_email"
    t.bigint "added_by_id"
    t.bigint "platform_agent_of_id"
    t.jsonb "role_ids", default: []
    t.boolean "platform_agent", default: false
    t.index ["added_by_id"], name: "index_memberships_on_added_by_id"
    t.index ["invitation_id"], name: "index_memberships_on_invitation_id"
    t.index ["platform_agent_of_id"], name: "index_memberships_on_platform_agent_of_id"
    t.index ["team_id"], name: "index_memberships_on_team_id"
    t.index ["user_id"], name: "index_memberships_on_user_id"
  end

  create_table "memberships_reassignments_assignments", force: :cascade do |t|
    t.bigint "membership_id", null: false
    t.bigint "scaffolding_completely_concrete_tangible_things_reassignments_i"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["membership_id"], name: "index_memberships_reassignments_assignments_on_membership_id"
    t.index ["scaffolding_completely_concrete_tangible_things_reassignments_i"], name: "index_assignments_on_tangible_things_reassignment_id"
  end

  create_table "memberships_reassignments_scaffolding_completely_concrete_tangi", force: :cascade do |t|
    t.bigint "membership_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["membership_id"], name: "index_tangible_things_reassignments_on_membership_id"
  end

  create_table "messages", id: :serial, force: :cascade do |t|
    t.integer "family_id"
    t.text "text"
    t.string "subheader"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
  end

  create_table "oauth_access_grants", force: :cascade do |t|
    t.bigint "resource_owner_id", null: false
    t.bigint "application_id", null: false
    t.string "token", null: false
    t.integer "expires_in", null: false
    t.text "redirect_uri", null: false
    t.datetime "created_at", precision: nil, null: false
    t.datetime "revoked_at", precision: nil
    t.string "scopes", default: "", null: false
    t.index ["application_id"], name: "index_oauth_access_grants_on_application_id"
    t.index ["resource_owner_id"], name: "index_oauth_access_grants_on_resource_owner_id"
    t.index ["token"], name: "index_oauth_access_grants_on_token", unique: true
  end

  create_table "oauth_access_tokens", force: :cascade do |t|
    t.bigint "resource_owner_id"
    t.bigint "application_id", null: false
    t.string "token", null: false
    t.string "refresh_token"
    t.integer "expires_in"
    t.datetime "revoked_at", precision: nil
    t.datetime "created_at", precision: nil, null: false
    t.string "scopes"
    t.string "previous_refresh_token", default: "", null: false
    t.string "description"
    t.datetime "last_used_at"
    t.boolean "provisioned", default: false
    t.index ["application_id"], name: "index_oauth_access_tokens_on_application_id"
    t.index ["refresh_token"], name: "index_oauth_access_tokens_on_refresh_token", unique: true
    t.index ["resource_owner_id"], name: "index_oauth_access_tokens_on_resource_owner_id"
    t.index ["token"], name: "index_oauth_access_tokens_on_token", unique: true
  end

  create_table "oauth_applications", force: :cascade do |t|
    t.string "name", null: false
    t.string "uid", null: false
    t.string "secret", null: false
    t.text "redirect_uri"
    t.string "scopes", default: "", null: false
    t.boolean "confidential", default: true, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "team_id"
    t.index ["team_id"], name: "index_oauth_applications_on_team_id"
    t.index ["uid"], name: "index_oauth_applications_on_uid", unique: true
  end

  create_table "oauth_stripe_accounts", force: :cascade do |t|
    t.string "uid"
    t.jsonb "data"
    t.bigint "user_id"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["uid"], name: "index_oauth_stripe_accounts_on_uid", unique: true
    t.index ["user_id"], name: "index_oauth_stripe_accounts_on_user_id"
  end

  create_table "payment_checks", id: :serial, force: :cascade do |t|
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.boolean "success", default: false, null: false
  end

  create_table "payments", id: :serial, force: :cascade do |t|
    t.decimal "amount", null: false
    t.string "from"
    t.string "reference"
    t.string "avi_id"
    t.integer "invoice_id"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.date "given_on"
    t.index ["amount", "from", "reference", "given_on"], name: "index_payments_on_amount_and_from_and_reference_and_given_on", unique: true
    t.index ["invoice_id"], name: "index_payments_on_invoice_id"
  end

  create_table "scaffolding_absolutely_abstract_creative_concepts", force: :cascade do |t|
    t.bigint "team_id", null: false
    t.string "name"
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["team_id"], name: "index_absolutely_abstract_creative_concepts_on_team_id"
  end

  create_table "scaffolding_absolutely_abstract_creative_concepts_collaborators", force: :cascade do |t|
    t.bigint "creative_concept_id", null: false
    t.bigint "membership_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.jsonb "role_ids", default: []
    t.index ["creative_concept_id"], name: "index_creative_concepts_collaborators_on_creative_concept_id"
    t.index ["membership_id"], name: "index_creative_concepts_collaborators_on_membership_id"
  end

  create_table "scaffolding_completely_concrete_tangible_things", force: :cascade do |t|
    t.bigint "absolutely_abstract_creative_concept_id", null: false
    t.string "text_field_value"
    t.string "button_value"
    t.string "cloudinary_image_value"
    t.date "date_field_value"
    t.string "email_field_value"
    t.string "password_field_value"
    t.string "phone_field_value"
    t.string "super_select_value"
    t.text "text_area_value"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "sort_order"
    t.datetime "date_and_time_field_value", precision: nil
    t.jsonb "multiple_button_values", default: []
    t.jsonb "multiple_super_select_values", default: []
    t.string "color_picker_value"
    t.boolean "boolean_button_value"
    t.string "option_value"
    t.jsonb "multiple_option_values", default: []
    t.index ["absolutely_abstract_creative_concept_id"], name: "index_tangible_things_on_creative_concept_id"
  end

  create_table "scaffolding_completely_concrete_tangible_things_assignments", force: :cascade do |t|
    t.bigint "tangible_thing_id"
    t.bigint "membership_id"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["membership_id"], name: "index_tangible_things_assignments_on_membership_id"
    t.index ["tangible_thing_id"], name: "index_tangible_things_assignments_on_tangible_thing_id"
  end

  create_table "teams", id: :serial, force: :cascade do |t|
    t.string "name"
    t.string "slug"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.boolean "being_destroyed"
    t.string "time_zone"
    t.string "locale"
  end

  create_table "users", id: :serial, force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at", precision: nil
    t.datetime "remember_created_at", precision: nil
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at", precision: nil
    t.datetime "last_sign_in_at", precision: nil
    t.inet "current_sign_in_ip"
    t.inet "last_sign_in_ip"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.integer "current_team_id"
    t.string "first_name"
    t.string "last_name"
    t.string "time_zone"
    t.datetime "last_seen_at", precision: nil
    t.string "profile_photo_id"
    t.jsonb "ability_cache"
    t.datetime "last_notification_email_sent_at", precision: nil
    t.boolean "former_user", default: false, null: false
    t.string "encrypted_otp_secret"
    t.string "encrypted_otp_secret_iv"
    t.string "encrypted_otp_secret_salt"
    t.integer "consumed_timestep"
    t.boolean "otp_required_for_login"
    t.string "otp_backup_codes", array: true
    t.string "locale"
    t.bigint "platform_agent_of_id"
    t.string "otp_secret"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["platform_agent_of_id"], name: "index_users_on_platform_agent_of_id"
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  create_table "versions", id: :serial, force: :cascade do |t|
    t.string "item_type", null: false
    t.integer "item_id", null: false
    t.string "event", null: false
    t.string "whodunnit"
    t.text "object"
    t.datetime "created_at", precision: nil
    t.index ["item_type", "item_id"], name: "index_versions_on_item_type_and_item_id"
  end

  create_table "webhooks_incoming_bullet_train_webhooks", force: :cascade do |t|
    t.jsonb "data"
    t.datetime "processed_at", precision: nil
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.datetime "verified_at", precision: nil
  end

  create_table "webhooks_incoming_oauth_stripe_account_webhooks", force: :cascade do |t|
    t.jsonb "data"
    t.datetime "processed_at", precision: nil
    t.datetime "verified_at", precision: nil
    t.bigint "oauth_stripe_account_id"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["oauth_stripe_account_id"], name: "index_stripe_webhooks_on_stripe_account_id"
  end

  create_table "webhooks_outgoing_deliveries", force: :cascade do |t|
    t.integer "endpoint_id"
    t.integer "event_id"
    t.text "endpoint_url"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.datetime "delivered_at", precision: nil
  end

  create_table "webhooks_outgoing_delivery_attempts", force: :cascade do |t|
    t.integer "delivery_id"
    t.integer "response_code"
    t.text "response_body"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.text "response_message"
    t.text "error_message"
    t.integer "attempt_number"
  end

  create_table "webhooks_outgoing_endpoints", force: :cascade do |t|
    t.bigint "team_id"
    t.text "url"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.string "name"
    t.jsonb "event_type_ids", default: []
    t.bigint "scaffolding_absolutely_abstract_creative_concept_id"
    t.integer "api_version", null: false
    t.index ["scaffolding_absolutely_abstract_creative_concept_id"], name: "index_endpoints_on_abstract_creative_concept_id"
    t.index ["team_id"], name: "index_webhooks_outgoing_endpoints_on_team_id"
  end

  create_table "webhooks_outgoing_events", force: :cascade do |t|
    t.integer "subject_id"
    t.string "subject_type"
    t.jsonb "data"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.bigint "team_id"
    t.string "uuid"
    t.jsonb "payload"
    t.string "event_type_id"
    t.integer "api_version", null: false
    t.index ["team_id"], name: "index_webhooks_outgoing_events_on_team_id"
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "integrations_stripe_installations", "oauth_stripe_accounts"
  add_foreign_key "integrations_stripe_installations", "teams"
  add_foreign_key "invitations", "teams"
  add_foreign_key "invoices", "families"
  add_foreign_key "kids", "families"
  add_foreign_key "memberships", "invitations"
  add_foreign_key "memberships", "memberships", column: "added_by_id"
  add_foreign_key "memberships", "oauth_applications", column: "platform_agent_of_id"
  add_foreign_key "memberships", "teams"
  add_foreign_key "memberships", "users"
  add_foreign_key "memberships_reassignments_assignments", "memberships"
  add_foreign_key "memberships_reassignments_assignments", "memberships_reassignments_scaffolding_completely_concrete_tangi", column: "scaffolding_completely_concrete_tangible_things_reassignments_i"
  add_foreign_key "memberships_reassignments_scaffolding_completely_concrete_tangi", "memberships"
  add_foreign_key "oauth_access_grants", "oauth_applications", column: "application_id"
  add_foreign_key "oauth_access_tokens", "oauth_applications", column: "application_id"
  add_foreign_key "oauth_applications", "teams"
  add_foreign_key "oauth_stripe_accounts", "users"
  add_foreign_key "payments", "invoices"
  add_foreign_key "scaffolding_absolutely_abstract_creative_concepts", "teams"
  add_foreign_key "scaffolding_absolutely_abstract_creative_concepts_collaborators", "memberships"
  add_foreign_key "scaffolding_absolutely_abstract_creative_concepts_collaborators", "scaffolding_absolutely_abstract_creative_concepts", column: "creative_concept_id"
  add_foreign_key "scaffolding_completely_concrete_tangible_things", "scaffolding_absolutely_abstract_creative_concepts", column: "absolutely_abstract_creative_concept_id"
  add_foreign_key "scaffolding_completely_concrete_tangible_things_assignments", "memberships"
  add_foreign_key "scaffolding_completely_concrete_tangible_things_assignments", "scaffolding_completely_concrete_tangible_things", column: "tangible_thing_id"
  add_foreign_key "users", "oauth_applications", column: "platform_agent_of_id"
  add_foreign_key "webhooks_outgoing_endpoints", "scaffolding_absolutely_abstract_creative_concepts"
  add_foreign_key "webhooks_outgoing_endpoints", "teams"
  add_foreign_key "webhooks_outgoing_events", "teams"
end
