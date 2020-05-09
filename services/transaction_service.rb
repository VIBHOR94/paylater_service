# frozen_string_literal: true

class TransactionService < ApplicationService
  def initialize(transaction)
    @transaction = transaction
    @error_message = nil
  end

  def transact
    initiate_transaction
    if successfull_transaction?
      puts 'success!'
    else
      puts "rejected! (reason: #{@error_message})"
    end
  end

  def self.fetch_transaction_instance(command)
    command_args = command.split(' ')
    user_name = command_args[2]
    merchant_name = command_args[3]
    amount = command_args[4]

    user_id = User.find_by(name: user_name)&.id
    merchant_id = Merchant.find_by(name: merchant_name)&.id

    return if entity_check_failed?(user_id, merchant_id)

    Transaction.new(user_id: user_id, merchant_id: merchant_id, amount: amount)
  end

  def self.entity_check_failed?(user_id, merchant_id)
    puts 'User not found.' if user_id.nil?
    puts 'Merchant not found.' if merchant_id.nil?
    (user_id.nil? || merchant_id.nil?)
  end

  private

  def initiate_transaction
    user = User.find(@transaction.user_id)
    amount = @transaction.amount

    begin
      ActiveRecord::Base.transaction do
        user.lock!
        @transaction.lock!

        user.withdraw(amount)
        @transaction.success_save
      end
    rescue StandardError => e
      @error_message = e.message
      @transaction.fail_save(@error_message)
    end
  end

  def successfull_transaction?
    @error_message.nil?
  end
end
