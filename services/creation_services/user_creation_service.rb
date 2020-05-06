# frozen_string_literal: true

require_relative '../../models/user'

class UserCreationService
  def self.create_user(user_name, email, credit_limit)
    @user = User.new(name: user_name, email: email, credit_limit: credit_limit)
    if @user.save
      puts 'User created successfully'
    else
      puts @user.errors.full_messages
    end
  end

  def self.process(command)
    command_args = command.split(' ')

    user_name = command_args[2]
    email = command_args[3]
    credit_limit = command_args[4]
    create_user(user_name, email, credit_limit)
  end
end
