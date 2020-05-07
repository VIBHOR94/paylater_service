# frozen_string_literal: true

require_relative './services/user_service.rb'

class PaylaterService
  def self.process(command)
    return unless new_user_command?(command)

    user = UserService.fetch_user_instance(command)
    UserService.new(user).create_user
  end

  def self.new_user_command?(command)
    command_args = command.split(' ')
    (command_args[0] == 'new') && (command_args[1] == 'user')
  end
end
