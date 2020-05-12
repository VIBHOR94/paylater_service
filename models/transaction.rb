# frozen_string_literal: true

require_relative './application_record.rb'

class Transaction < ApplicationRecord
  self.table_name = 'transactions'

  belongs_to :user, required: true
  belongs_to :merchant, required: true

  validates :transaction_amount, presence: true
  validates :merchant_amount, presence: true
  validates :status, presence: true

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

  def process_merchant_amount(percentage_discount)
    percentage_discount = percentage_discount.to_f
    self.merchant_amount = (transaction_amount * (100 - percentage_discount))
                           .to_f / 100
    self
  end
end
