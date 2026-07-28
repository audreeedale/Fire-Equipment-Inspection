class Asset < ApplicationRecord
  belongs_to :address
  belongs_to :building, optional: true
  has_many :asset_inspection_records, dependent: :destroy
  has_many :inspection_visits, through: :asset_inspection_records

  enum :category, {
    fire_extinguisher: 0, hydrant: 1, fire_hose_reel: 2,
    exit_light: 3, fire_door: 4, smoke_alarm: 5
  }

  validates :asset_no, presence: true, uniqueness: { scope: :address_id }
  validates :category, presence: true

  scope :active, -> { where(active: true) }

  store_accessor :details, :size_and_type, :type_code, :brand, :length

  def latest_record
    asset_inspection_records.joins(:inspection_visit).order("inspection_visits.visit_date DESC").first
  end
end
