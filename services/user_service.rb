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

  def self.fetch_user_instance(command)
    command_args = command.split(' ')

    user_name = command_args[2]
    email = command_args[3]
    credit_limit = command_args[4]

    User.new(name: user_name, email: email, credit_limit: credit_limit)
  end
end
