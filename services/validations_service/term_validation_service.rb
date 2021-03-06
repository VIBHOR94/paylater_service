# frozen_string_literal: true

class TermValidationService
  VALID_NAME_REGEX = /^[a-zA-Z\-\`]++(?: [a-zA-Z\-\`]++)?[0-9]*$/i.freeze
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i.freeze

  def self.valid_name?(input_name)
    !(input_name =~ VALID_NAME_REGEX).nil?
  end

  def self.valid_email?(email)
    !(email =~ VALID_EMAIL_REGEX).nil?
  end

  def self.valid_credit?(credit)
    (valid_float_value? credit) && credit.to_f.positive?
  end

  def self.valid_percentage?(percent)
    return false if percent.to_s.split('').last != '%'

    percent_value = percent.delete_suffix('%')
    (valid_float_value? percent_value) && percent_value.to_f >= 0
  end

  def self.valid_amount?(amount)
    (amount.is_a? Numeric) || (amount.to_i.to_s == amount)
  end

  def self.valid_float_value?(num)
    (begin
       true if Float(num)
     rescue StandardError
       false
     end)
  end
end
