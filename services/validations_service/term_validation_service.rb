# frozen_string_literal: true

class TermValidationService
  VALID_NAME_REGEX = /^[a-zA-Z]+$/i.freeze
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i.freeze
  VALID_AMOUNT_REGEX = /^-?\d+\.?\d*$/.freeze

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
    !(amount =~ VALID_AMOUNT_REGEX).nil?
  end

  def self.valid_float_value?(num)
    (begin
       true if Float(num)
     rescue StandardError
       false
     end)
  end
end
