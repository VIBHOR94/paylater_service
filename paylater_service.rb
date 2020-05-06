# frozen_string_literal: true

require_relative './services/creation_services/user_creation_service.rb'

class PaylaterService
  def initialize(command)
    @command = command
  end

  def process
    return UserCreationService.process(@command) if new_user_command?
  end

  private

  def new_user_command?
    command_args = @command.split(' ')
    (command_args[0] == 'new') && (command_args[1] == 'user')
  end
end
