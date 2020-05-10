# frozen_string_literal: true

require_relative './application_record.rb'

class User < ApplicationRecord
  self.table_name = 'users'
  before_validation :set_dues, on: :create

  has_many :transactions
  has_many :merchants, through: :transactions

  validates :name, uniqueness: true
  validates :email, uniqueness: true

  validates :credit_limit, presence: true
  validates_numericality_of :credit_limit, greater_than_or_equal_to: 0

  validates :dues, presence: true
  validates_numericality_of :dues, less_than_or_equal_to: :credit_limit

  def set_dues
    self.dues ||= 0
  end

  def available_credit
    credit_limit - dues
  end

  def withdraw(withdrawl_amount)
    can_withdraw = credit_limit >= (dues + withdrawl_amount.to_f)
    raise 'Insufficient credit to perform transaction' unless can_withdraw

    self.dues += withdrawl_amount
    save!
  end
end
