# frozen_string_literal: true

require_relative './application_record.rb'

class Transaction < ApplicationRecord
  self.table_name = 'transactions'

  belongs_to :user
  belongs_to :merchant

  validates :amount, presence: true

  def success_save
    # Method can be used later to trigger email to user and merchant
    # via some kind f delayed job
    self.status = 'SUCCESS'
    save!
  end

  def fail_save(message)
    # Method can be used later to trigger email to user and internal team
    # via some kind f delayed job for checking error
    self.status = "FAILED - #{message}"
    save!
  end
end
