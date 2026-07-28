class AssetInspectionRecord < ApplicationRecord
  belongs_to :asset
  belongs_to :inspection_visit
  has_many_attached :photos

  enum :defect_status, {
    critical: 0, non_critical: 1, non_conformance: 2,
    pending_assessment: 3, none: 4, recommendation: 5
  }, prefix: true

  validates :asset_id, uniqueness: { scope: :inspection_visit_id }
  validates :defect_status, presence: true

  scope :with_defects, -> { where.not(defect_status: :none) }
end
