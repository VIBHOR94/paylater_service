require_relative './term_validation_service.rb'
# frozen_string_literal: true

class CommandValidationService
  FIRST_VALID_ARG = %w[new update payback report].freeze

  def self.validate(command)
    command_args = command.split(' ')

    return false if command_args.length < 2
    return false unless FIRST_VALID_ARG.include? command_args[0]
    unless send("valid_for_#{command_args[0]}_command?", command_args)
      return false
    end

    true
  end

  def self.valid_for_new_command?(command_args)
    return false unless %w[user merchant txn].include? command_args[1]

    send("validate_new_#{command_args[1]}_command", command_args)
  end

  def self.valid_for_update_command?(command_args)
    return unless command_args[1] == 'merchant'

    validate_update_merchant_command command_args
  end

  def self.valid_for_payback_command?(command_args)
    command_args.length == 3
  end

  def self.valid_for_report_command?(command_args)
    valid_second_arg = %w[discount dues users-at-credit-limit total-dues]
    return false unless valid_second_arg.include? command_args[1]
    if %w[users-at-credit-limit total-dues].include? command_args[1]
      return command_args.length == 2
    end

    command_args.length == 3
  end

  def self.validate_new_user_command(command_args)
    command_args.length.equal? 5
  end

  def self.validate_new_merchant_command(command_args)
    command_args.length.equal? 5
  end

  def self.validate_new_txn_command(command_args)
    command_args.length.equal? 5
  end

  def self.validate_update_merchant_command(command_args)
    return false unless command_args.length.equal? 5
    return false unless %w[interest].include? command_args[3]

    true
  end
end
