class Building < ApplicationRecord
  belongs_to :address
  has_many :assets, dependent: :nullify
  has_many :schedules, dependent: :nullify

  validates :name, presence: true, uniqueness: { scope: :address_id }
end
