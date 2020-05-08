# frozen_string_literal: true

require_relative './paylater_application.rb'
require_relative './services/validations_service/command_validation_service.rb'

def initiate_service
  puts greeting_message
  puts 'Please enter a command to get started.'
  puts "Type 'exit' or press Ctrl + C to exit"
  process_inputs
end

def greeting_message
  'Welcome to Paylater Service Command Line Interface App.'
end

def process_inputs
  loop do
    puts '*****************************************************************'
    user_input = gets.chomp
    return if user_input == 'exit'

    if valid?(user_input)
      PaylaterApplication.process(user_input)
    else
      invalid_input_message
    end
  end
end

def valid?(command)
  CommandValidationService.validate command
end

def invalid_input_message
  puts 'Invalid command. Please try again'
end

initiate_service
