# frozen_string_literal: true

require_relative './application_record.rb'

class Merchant < ApplicationRecord
  self.table_name = 'merchants'

  before_validation :validate_name, :validate_email

  has_many :transactions
  has_many :users, through: :transactions

  validates :name, uniqueness: true
  validates :email, uniqueness: true
  validates :discount_percentage, presence: true

  validates_numericality_of :discount_percentage, greater_than_or_equal_to: 0
  validates_numericality_of :discount_percentage, less_than_or_equal_to: 100

  private

  def validate_name
    errors.add(:name, "Invalid name #{name}") unless
     TermValidationService.valid_name?(name)
  end

  def validate_email
    errors.add(:email, "Invalid email #{email}") unless
     TermValidationService.valid_email?(email)
  end
end
