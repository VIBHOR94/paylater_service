# frozen_string_literal: true

class MerchantService < ApplicationService
  def initialize(merchant)
    @merchant = merchant
  end

  def create_merchant
    if @merchant.save
      puts "#{@merchant['name']} (#{@merchant['discount_percentage']})"
    else
      puts 'Following error/s occured while creating the record'
      puts @merchant.errors.full_messages
    end
  end

  def update_merchant
    if @merchant.save
      # Notify merchant via mail
      puts "interest-rate: #{@merchant.discount_percentage}%"
    else
      # Notify merchant and internal team about the same
      puts 'Following error/s occured while updating the record'
      puts @merchant.errors.full_messages
    end
  end

  def self.fetch_merchant_instance(command)
    command_args = command.split(' ')

    merchant_name = command_args[2]
    email = command_args[3]
    discount_percentage = command_args[4].delete_suffix('%')

    Merchant.new(
      name: merchant_name,
      email: email,
      discount_percentage: discount_percentage
    )
  end

  def self.find_and_update(command)
    command_args = command.split(' ')
    merchant_name = command_args[2]
    field_name = fetch_field_name(command_args[3])

    unless field_name
      (puts "No field with #{command_args[3]} found" && return)
    end

    merchant = Merchant.find_by(name: merchant_name)
    return puts('Merchant not found') unless merchant

    merchant[field_name] = command_args[4].delete_suffix('%')
    MerchantService.new(merchant).update_merchant
  end

  def self.fetch_field_name(input)
    # Can be used for another field updation too
    return 'discount_percentage' if input == 'interest'
  end

  def self.discount_info(command)
    command_args = command.split(' ')

    merchant_name = command_args[2]
    merchant = Merchant.find_by(name: merchant_name)
    return puts('Merchant not found') unless merchant

    puts merchant.discount_percentage
  end
end
