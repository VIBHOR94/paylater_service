# frozen_string_literal: true

require_relative '../../models/user'

class UserCreationService
  def self.create(user_name, email, credit_limit)
    @user = User.new(name: user_name, email: email, credit_limit: credit_limit)
    if @user.save
      puts 'User created successfully'
    else
      puts @user.errors.full_messages
    end
  end
end
