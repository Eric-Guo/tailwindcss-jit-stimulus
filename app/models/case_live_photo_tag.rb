# frozen_string_literal: true

class CaseLivePhotoTag < ApplicationRecord
  belongs_to :case_live_photo, class_name: "CaseLivePhoto", foreign_key: "case_live_photo_id"

  belongs_to :material, class_name: "Material", foreign_key: "material_id"
end
