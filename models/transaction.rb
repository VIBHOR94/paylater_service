# frozen_string_literal: true

require_relative './application_record.rb'

class Transaction < ApplicationRecord
  self.table_name = 'transactions'

  belongs_to :user
  belongs_to :merchant

  validates :amount, presence: true

  def success
    self.status = 'SUCCESS'
    self
  end

  def failed(message)
    self.status = "FAILED - #{message}"
    self
  end
end
