# frozen_string_literal: true

require('./paylater_service.rb')

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
    user_input = gets.chomp
    puts user_input
    # TODO: - Is valid input -> pass it to PaykaterService else throw error.
    # (isvalid user_input) ? PaylaterService.new(user_input) : invalid_input_message
  end
end

initiate_service
