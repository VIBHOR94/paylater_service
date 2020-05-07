# frozen_string_literal: true

require_relative '../models/merchant'

class MerchantService
  def initialize(merchant)
    @merchant = merchant
  end

  def create_merchant
    if @merchant.save
      puts "#{@merchant["name"]} (#{@merchant["discount_percentage"]})"
    else
      puts 'Following error/s occured while creating the record'
      puts @merchant.errors.full_messages
    end
  end

  def self.fetch_merchant_instance(command)
    command_args = command.split(' ')

    merchant_name = command_args[2]
    email = command_args[3]
    discount_percentage = command_args[4]

    Merchant.new(name: merchant_name, email: email, discount_percentage: discount_percentage)
  end
end
