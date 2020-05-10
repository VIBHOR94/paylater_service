# frozen_string_literal: true

require_relative './application_record.rb'

class User < ApplicationRecord
  self.table_name = 'users'

  has_many :transactions
  has_many :merchants, through: :transactions

  validates :name, uniqueness: true
  validates :email, uniqueness: true
  validates :credit_limit, presence: true
  validates_numericality_of :credit_limit, :greater_than_or_equal_to => 0

  def withdraw(amount)
    raise 'Insufficient credit to perform transaction' if credit_limit < amount

    self.credit_limit -= amount
    save!
  end
end
