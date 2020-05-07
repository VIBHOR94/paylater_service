require_relative './application_record.rb'

class Merchant < ApplicationRecord
  self.table_name = 'merchants'

  validates :name, uniqueness: true
  validates :email, uniqueness: true
  validates :discount_percentage, presence: true
end
