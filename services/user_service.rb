# frozen_string_literal: true

require_relative './application_service.rb'

class UserService < ApplicationService
  def initialize(user)
    @user = user
  end

  def create_user
    if @user.save
      puts "#{@user['name']} (#{@user['credit_limit']})"
    else
      puts 'Following error/s occured while creating the record'
      puts @user.errors.full_messages
    end
  end

  def update_user
    if @user.save
      puts "#{@user['name']} updated.
            New credit limit is (#{@user['credit_limit']})"
    else
      puts 'Following error/s occured while updating the record'
      puts @user.errors.full_messages
    end
  end

  def self.fetch_user_instance(command)
    command_args = command.split(' ')

    user_name = command_args[2]
    email = command_args[3]
    credit_limit = command_args[4]

    User.new(name: user_name, email: email, credit_limit: credit_limit)
  end

  def self.payback(command)
    command_args = command.split(' ')
    user_name = command_args[1]
    amount = command_args[2].to_f

    user = User.find_by(name: user_name)
    return puts('User not found') unless user

    user['credit_limit'] += amount
    UserService.new(user).update_user
  end
end
