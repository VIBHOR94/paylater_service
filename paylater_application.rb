# frozen_string_literal: true

require_relative './services/user_service.rb'
require_relative './services/merchant_service.rb'
require_relative './services/transaction_service.rb'

class PaylaterApplication
  def self.process(command)
    # Using class instance variable
    @command = command
    @command_args = @command.split(' ')

    entities = %w[user merchant txn]
    entities.each do |entity|
      return send("trigger_#{entity}_service", 'new') if new_command?(entity)
    end
    return if merchant_service_concern?

    user_service_concern?
  end

  def self.merchant_service_concern?
    processed = false
    if update_merchant_command?
      trigger_merchant_service('update')
      processed = true
    elsif report_merchant_discount_command?
      trigger_merchant_service('discount_info')
      processed = true
    end
    processed
  end

  def self.user_service_concern?
    if user_payback_command?
      trigger_user_service('payback')
    elsif report_dues_command?
      trigger_user_service('dues_info')
    elsif report_exhaused_limit_users_command?
      trigger_user_service('exhausted_limit')
    elsif report_users_dues_command?
      trigger_user_service('report_all_dues')
    end
  end

  def self.new_command?(entity)
    match_params('new', entity)
  end

  def self.update_merchant_command?
    match_params('update', 'merchant')
  end

  def self.user_payback_command?
    @command_args[0] == 'payback'
  end

  def self.report_dues_command?
    match_params('report', 'dues')
  end

  def self.report_merchant_discount_command?
    match_params('report', 'discount')
  end

  def self.report_exhaused_limit_users_command?
    match_params('report', 'users-at-credit-limit')
  end

  def self.report_users_dues_command?
    match_params('report', 'total-dues')
  end

  def self.match_params(first_param, second_param)
    @command_args[0] == first_param && @command_args[1] == second_param
  end

  def self.trigger_user_service(operation)
    if operation == 'new'
      user = UserService.fetch_user_instance(@command)
      UserService.new(user).create_user
    elsif operation == 'exhausted_limit'
      UserService.exhausted_limit_user_names
    elsif %w[payback dues_info].include? operation
      UserService.send(operation, @command)
    end
    UserService.report_all_dues if operation == 'report_all_dues'
  end

  def self.trigger_merchant_service(operation)
    if operation == 'new'
      merchant = MerchantService.fetch_merchant_instance(@command)
      MerchantService.new(merchant).create_merchant
    elsif operation == 'update'
      MerchantService.find_and_update(@command)
    elsif operation == 'discount_info'
      MerchantService.discount_info(@command)
    end
  end

  def self.trigger_txn_service(operation)
    return unless operation == 'new'

    transaction = TransactionService.fetch_transaction_instance(@command)
    TransactionService.new(transaction).transact if transaction
  end
end
