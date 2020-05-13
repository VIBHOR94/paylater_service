# frozen_string_literal: true

require_relative './application_record.rb'

class User < ApplicationRecord
  self.table_name = 'users'
  before_validation :set_dues, on: :create
  before_validation :validate_dues, on: :update
  before_validation :validate_name, :validate_email

  has_many :transactions
  has_many :merchants, through: :transactions

  validates :name, presence: true
  validates :name, uniqueness: true

  validates :email, presence: true
  validates :email, uniqueness: true

  validates :credit_limit, presence: true
  validates_numericality_of :credit_limit, greater_than_or_equal_to: 0

  validates :dues, presence: true

  def set_dues
    self.dues = 0
  end

  def available_credit
    credit_limit - dues
  end

  def withdraw(withdrawl_amount)
    can_withdraw = credit_limit >= (dues + withdrawl_amount.to_f)
    raise 'Insufficient credit to perform transaction' unless can_withdraw

    self.dues += withdrawl_amount
  end

  def self.exhausted_limit_users
    where('dues = credit_limit').pluck(:name)
  end

  def self.fetch_name_and_dues
    select('name, dues')
  end

  def payback(amount)
    return unless validate_amount(amount)

    self.dues -= amount.to_f
  end

  private

  def validate_name
    return unless name

    errors.add(:name, "Invalid name #{name}") unless
     TermValidationService.valid_name?(name)
  end

  def validate_email
    return unless email

    errors.add(:email, "Invalid email #{email}") unless
     TermValidationService.valid_email?(email)
  end

  def validate_dues
    return unless dues > credit_limit

    errors.add(:dues, "Payback #{credit_limit - dues} exceeds ")
  end

  def validate_amount(amount)
    if TermValidationService.valid_amount?(amount) && amount.to_f.positive?
      return true
    end

    errors.add(:dues, "Invalid payback amount #{amount}")
    false
  end
end
