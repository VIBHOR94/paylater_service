# frozen_string_literal: true

require 'rspec'
require_relative '../../../models/merchant.rb'

RSpec.describe Merchant do
  describe 'Checks all the validations' do
    let(:alphabets) { ('a'..'z').to_a + ('A'..'Z').to_a }
    let(:non_alphabets) { (0..9).to_a + %w[+ - _ $ %] }

    after(:each) { Merchant.delete_all }

    it 'throws error for empty name' do
      merchant = Merchant.new
      merchant.save
      expect(merchant.errors[:name].present?).to be(true)
      expect(merchant.errors[:name].first).to eq("can't be blank")
    end

    it 'accepts valid name' do
      valid_name = alphabets.shuffle.join('')[0, 10]
      merchant = Merchant.new(name: valid_name)
      merchant.save

      expect(merchant.errors[:name].present?).to be(false)
    end

    it 'throws error for invalid name' do
      invalid_name = (alphabets.sample(9) + [non_alphabets.sample.to_s])
                     .shuffle.join('') + alphabets.sample

      merchant = Merchant.new(name: invalid_name)
      merchant.save

      expect(merchant.errors[:name].present?).to be(true)
      expect(merchant.errors[:name].first)
        .to eq("Invalid name #{invalid_name}")
    end

    it 'checks uniqueness of name' do
      valid_name = alphabets.shuffle.join('')[0, 10]
      merchant = Merchant.create(
        name: valid_name,
        email: 'xyz@abc.com',
        discount_percentage: 5.0
      )

      merchant_two = Merchant.create(
        name: valid_name,
        email: 'xyz1@abdc.com',
        discount_percentage: 7.0
      )

      expect(merchant.errors[:name].present?).to be(false)
      expect(
        merchant_two.errors[:name]
        .include?('has already been taken')
      )
        .to be(true)
    end

    it 'throws error for empty email' do
      merchant = Merchant.new
      merchant.save
      expect(merchant.errors[:email].present?).to be(true)
      expect(merchant.errors[:email].first).to eq("can't be blank")
    end

    it 'accepts valid email' do
      valid_email = [
        'abc123@xyz.in',
        'wasw@afa.com',
        'aee121@fbs.co.in'
      ].sample

      merchant = Merchant.new(email: valid_email)
      merchant.save

      expect(merchant.errors[:email].present?).to be(false)
    end

    it 'throws error for invalid email' do
      invalid_email = [
        'ab$&c123@xyz.in',
        'wasw*#@afa.com',
        '-(aee121@fbs.co.in'
      ].sample

      merchant = Merchant.new(email: invalid_email)
      merchant.save

      expect(merchant.errors[:email].present?).to be(true)
    end

    it 'throws error for no dicount percentage' do
      merchant = Merchant.new
      merchant.save
      expect(merchant.errors[:discount_percentage].present?).to be(true)
      expect(merchant.errors[:discount_percentage].first)
        .to eq("can't be blank")
    end

    it 'throws error for dicount percentage < 0' do
      merchant = Merchant.new(discount_percentage: -5.0)
      merchant.save
      expect(merchant.errors[:discount_percentage].present?).to be(true)
      expect(merchant.errors[:discount_percentage].first)
        .to eq('must be greater than or equal to 0')
    end

    it 'throws error for dicount percentage > 100' do
      merchant = Merchant.new(discount_percentage: 105.0)
      merchant.save
      expect(merchant.errors[:discount_percentage].present?).to be(true)
      expect(merchant.errors[:discount_percentage].first)
        .to eq('must be less than or equal to 100')
    end

    it 'accepts dicount percentage < 100 and > 0' do
      merchant = Merchant.new(discount_percentage: (0..100).to_a.sample)
      merchant.save
      expect(merchant.errors[:discount_percentage].present?).to be(false)
    end
  end
end
