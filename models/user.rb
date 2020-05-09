# frozen_string_literal: true

require_relative './application_record.rb'

class User < ApplicationRecord
  self.table_name = 'users'

  has_many :transactions
  has_many :merchants, through: :transactions

  validates :name, uniqueness: true
  validates :email, uniqueness: true

  def withdraw(amount)
    raise 'Insufficient credit to perform transaction' if credit_limit < amount

    self.credit_limit -= amount
    save!
  end
end
