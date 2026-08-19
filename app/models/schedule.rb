class Schedule < ApplicationRecord
  belongs_to :address
  belongs_to :building, optional: true
  has_many :schedule_completions, dependent: :destroy
  has_many :inspection_visits, through: :schedule_completions

  enum :frequency, { monthly: 0, six_monthly: 1, annual: 2 }
  enum :equipment_category, {
    fire_extinguisher: 0, hydrant: 1, fire_hose_reel: 2,
    exit_light: 3, fire_door: 4, smoke_alarm: 5
  }, prefix: :category

  validates :start_date, :next_due_on, presence: true
  validates :grace_period_days, numericality: { greater_than_or_equal_to: 0 }

  scope :active, -> { where(active: true) }

  FREQUENCY_INTERVALS = { "monthly" => 1.month, "six_monthly" => 6.months, "annual" => 1.year }.freeze

  before_validation :set_initial_next_due_on, on: :create

  def self.due_soon_count
    active.count { |schedule| schedule.status == :due_soon }
  end

  def recompute_next_due!(from_date = last_completed_on || start_date)
    update!(next_due_on: from_date + FREQUENCY_INTERVALS.fetch(frequency))
  end

  def mark_completed!(on_date)
    update!(last_completed_on: on_date)
    recompute_next_due!(on_date)
  end

  # Computed at read-time, not stored: only next_due_on/last_completed_on are persisted
  # (updated on the rare completion event), so this never goes stale without a cron job.
  def status
    return :inactive unless active?
    today = Time.zone.today
    if next_due_on < today
      :overdue
    elsif next_due_on <= today + grace_period_days
      :due_soon
    else
      :upcoming
    end
  end

  private

  def set_initial_next_due_on
    return if next_due_on.present? || start_date.blank? || frequency.blank?
    self.next_due_on = start_date + FREQUENCY_INTERVALS.fetch(frequency)
  end
end
