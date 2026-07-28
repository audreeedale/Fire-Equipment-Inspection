class Address < ApplicationRecord
  has_many :buildings, dependent: :destroy
  has_many :schedules, dependent: :destroy
  has_many :inspection_visits, dependent: :destroy
  has_many :assets, dependent: :destroy

  validates :street_address, :suburb, :state, :postcode, presence: true
  validates :postcode, format: { with: /\A\d{4}\z/, message: "must be 4 digits (AU postcode)" }

  def display_name
    name.presence || "#{street_address}, #{suburb} #{state} #{postcode}"
  end

  def overall_status
    statuses = schedules.active.map(&:status)
    return :no_schedule if statuses.empty?
    return :overdue if statuses.include?(:overdue)
    return :due_soon if statuses.include?(:due_soon)
    :upcoming
  end
end
