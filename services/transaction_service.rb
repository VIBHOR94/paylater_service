# frozen_string_literal: true

class TransactionService < ApplicationService
  def initialize(transaction)
    @transaction = transaction
    @error_message = nil
  end

  def transact
    initiate_transaction
    if successfull_transaction?
      # Can be used to trigger a mail to user and merchant
      # via NotificationService through delayed job
      puts 'success!'
    else
      # Can be used to trigger a mail to user and internal error reviewal team
      # via NotificationService through delayed job
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

    Transaction.new(user_id: user_id, merchant_id: merchant_id, transaction_amount: amount)
  end

  def self.entity_check_failed?(user_id, merchant_id)
    puts 'User not found.' if user_id.nil?
    puts 'Merchant not found.' if merchant_id.nil?
    (user_id.nil? || merchant_id.nil?)
  end

  private

  def initiate_transaction
    # Trigger a mail to user about beginning of txn
    # During transaction and save it in transaction table
    ActiveRecord::Base.transaction do
      user = User.find(@transaction.user_id)
      user.lock!
      @transaction.lock!
      discount_percentage = Merchant.find(@transaction.merchant_id).discount_percentage
      @transaction.set_merchant_amount(discount_percentage)
      user.withdraw(@transaction.transaction_amount)
      @transaction.success.save!
    end
    rescue StandardError => e
      @error_message = e.message
      @transaction.set_merchant_amount(100)
      @transaction.failed(@error_message).save!
  end

  def successfull_transaction?
    @error_message.nil?
  end
end
