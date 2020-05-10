# frozen_string_literal: true

require_relative './dependencies.rb'

class PaylaterApplication
  def self.process(command)
    entities = %w[user merchant txn]
    entities.each do |entity|
      if new_command?(command, entity)
        return send("trigger_#{entity}_service", command, 'new')
      end
    end
    trigger_merchant_service(command, 'update') if update_merchant?(command)
  end

  def self.new_command?(command, entity)
    command_args = command.split(' ')
    (command_args[0] == 'new') && (command_args[1] == entity)
  end

  def self.update_merchant?(command)
    command_args = command.split(' ')
    (command_args[0] == 'update') && (command_args[1] == 'merchant')
  end

  def self.trigger_user_service(command, operation)
    return unless operation == 'new'

    user = UserService.fetch_user_instance(command)
    UserService.new(user).create_user
  end

  def self.trigger_merchant_service(command, operation)
    if operation == 'new'
      merchant = MerchantService.fetch_merchant_instance(command)
      MerchantService.new(merchant).create_merchant
    elsif operation == 'update'
      MerchantService.find_and_update(command)
    end
  end

  def self.trigger_txn_service(command, operation)
    return unless operation == 'new'

    transaction = TransactionService.fetch_transaction_instance(command)
    TransactionService.new(transaction).transact if transaction
  end
end
