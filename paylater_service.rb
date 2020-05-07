# frozen_string_literal: true

require_relative './services/user_service.rb'
require_relative './services/merchant_service.rb'

class PaylaterService
  def self.process(command)
    if new_user_command?(command)
        user = UserService.fetch_user_instance(command)
        UserService.new(user).create_user
    elsif new_merchant_command?(command)
        merchant = MerchantService.fetch_merchant_instance(command)
        MerchantService.new(merchant).create_merchant
    end
  end

  def self.new_user_command?(command)
    command_args = command.split(' ')
    (command_args[0] == 'new') && (command_args[1] == 'user')
  end

  def self.new_merchant_command?(command)
    command_args = command.split(' ')
    (command_args[0] == 'new') && (command_args[1] == 'merchant')
  end
end
