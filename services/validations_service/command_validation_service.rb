require_relative './term_validation_service.rb'
# frozen_string_literal: true

class CommandValidationService
  FIRST_VALID_ARG = %w[new update payback report].freeze

  def self.validate(command)
    command = command.downcase
    command_args = command.split(' ')

    return false if command_args.length < 2
    return false unless FIRST_VALID_ARG.include? command_args[0]
    unless send("valid_for_#{command_args[0]}_command?", command_args)
      return false
    end

    true
  end

  def self.valid_for_new_command?(command_args)
    return validate_new_user_command command_args if command_args[1] == 'user'
    if command_args[1] == 'merchant'
      return validate_new_merchant_command command_args
    end
    return validate_new_txn_command command_args if command_args[1] == 'txn'

    false
  end

  def self.valid_for_update_command?(command_args)
    return unless command_args[1] == 'merchant'

    validate_update_merchant_command command_args
  end

  def self.valid_for_payback_command?(command_args)
    user_name = command_args[1]
    amount = command_args[2]
    (TermValidationService.valid_name? user_name) &&
      (TermValidationService.valid_amount? amount)
  end

  def self.valid_for_report_command?(command_args)
    valid_second_arg = %w[discount dues users-at-credit-limit total-dues]
    return false unless valid_second_arg.include? command_args[1]

    if command_args[1] == 'discount'
      user_name = command_args[2]
      return TermValidationService.valid_name? user_name
    elsif command_args[1] == 'dues'
      merchant_name = command_args[2]
      return TermValidationService.valid_name? merchant_name
    end
    true
  end

  def self.validate_new_user_command(command_args)
    return false unless command_args.length.equal? 5

    user_name = command_args[2]
    user_email = command_args[3]
    credit = command_args[4]

    (TermValidationService.valid_name? user_name) &&
      (TermValidationService.valid_email? user_email) &&
      (TermValidationService.valid_credit? credit)
  end

  def self.validate_new_merchant_command(command_args)
    return false unless command_args.length.equal? 5

    merchant_name = command_args[2]
    merchant_email = command_args[3]
    discount_percentage = command_args[4]

    (TermValidationService.valid_name? merchant_name) &&
      (TermValidationService.valid_email? merchant_email) &&
      (TermValidationService.valid_percentage? discount_percentage)
  end

  def self.validate_new_txn_command(command_args)
    return false unless command_args.length.equal? 5

    user_name = command_args[2]
    merchant_name = command_args[3]
    amount = command_args[4]
    (TermValidationService.valid_name? user_name) &&
      (TermValidationService.valid_name? merchant_name) &&
      (TermValidationService.valid_amount? amount)
  end

  def self.validate_update_merchant_command(command_args)
    return false unless command_args.length.equal? 5
    return false unless %w[interest].include? command_args[3]

    merchant_name = command_args[2]
    discount_percentage = command_args[4]

    (TermValidationService.valid_name? merchant_name) &&
      (TermValidationService.valid_percentage? discount_percentage)
  end
end
