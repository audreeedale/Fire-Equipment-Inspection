class Defect < ApplicationRecord
  belongs_to :asset
  belongs_to :asset_inspection_record, optional: true

  delegate :address, to: :asset

  enum :priority, { low: 0, medium: 1, high: 2 }
  enum :status, { logged: 0, quoted: 1, scheduled: 2, resolved: 3 }

  validates :description, presence: true

  scope :open_defects, -> { where.not(status: :resolved) }
  scope :recent_first, -> { order(created_at: :desc) }

  STATUS_TRANSITIONS = { "logged" => "quoted", "quoted" => "scheduled", "scheduled" => "resolved" }.freeze

  def advance!
    next_status = STATUS_TRANSITIONS[status]
    return false unless next_status
    update!(status: next_status, resolved_on: next_status == "resolved" ? Date.current : nil)
    true
  end
end
