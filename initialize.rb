# frozen_string_literal: true

require_relative './paylater_service.rb'
require_relative './services/validations_service/command_validation_service.rb'

def initiate_service
  puts greeting_message
  puts 'Please enter a command to get started'
  process_inputs
end

def greeting_message
  'Welcome to Paylater Service Command Line Interface App.'
end

def process_inputs
  loop do
    puts '*****************************************************************'
    user_input = gets.chomp
    # TODO: - Is valid input -> pass it to PaykaterService else throw error.
    valid?(user_input) ? PaylaterService.new(user_input) : invalid_input_message
  end
end

def valid?(command)
  CommandValidationService.validate command
end

def invalid_input_message
  puts 'Invalid command. Please try again'
end

initiate_service
