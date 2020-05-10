# frozen_string_literal: true

require_relative './application_record.rb'

class Transaction < ApplicationRecord
  self.table_name = 'transactions'

  belongs_to :user
  belongs_to :merchant

  validates :transaction_amount, presence: true
  validates :merchant_amount, presence: true

  validates_numericality_of :transaction_amount, greater_than: 0
  validates_numericality_of :merchant_amount, greater_than_or_equal_to: 0

  def success
    self.status = 'SUCCESS'
    self
  end

  def failed(message)
    self.status = "FAILED - #{message}"
    self
  end

  def set_merchant_amount(percentage_discount)
    self.merchant_amount = (self.transaction_amount * (100 - percentage_discount.to_f)).to_f / 100
    self
  end
end
