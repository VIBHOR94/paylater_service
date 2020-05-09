# frozen_string_literal: true

require_relative './dependencies.rb'

class PaylaterApplication
  def self.process(command)
    entities = %w[user merchant txn]
    entities.each do |entity|
      if send('new_entity_command?', command, entity)
        return send("trigger_#{entity}_service", command)
      end
    end
  end

  def self.new_entity_command?(command, entity)
    command_args = command.split(' ')
    (command_args[0] == 'new') && (command_args[1] == entity)
  end

  def self.trigger_user_service(command)
    user = UserService.fetch_user_instance(command)
    UserService.new(user).create_user
  end

  def self.trigger_merchant_service(command)
    merchant = MerchantService.fetch_merchant_instance(command)
    MerchantService.new(merchant).create_merchant
  end

  def self.trigger_txn_service(command)
    transaction = TransactionService.fetch_transaction_instance(command)
    TransactionService.new(transaction).transact if transaction
  end
end
