class InspectionVisit < ApplicationRecord
  belongs_to :address
  has_many :asset_inspection_records, dependent: :destroy
  has_many :assets, through: :asset_inspection_records
  has_many :schedule_completions, dependent: :destroy
  has_many :schedules, through: :schedule_completions

  enum :status, { in_progress: 0, completed: 1, cancelled: 2 }

  validates :visit_date, presence: true

  scope :recent_first, -> { order(visit_date: :desc) }

  def seed_records_for_all_assets!
    address.assets.active.find_each do |asset|
      asset_inspection_records.find_or_create_by!(asset: asset)
    end
  end
end
