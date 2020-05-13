# frozen_string_literal: true

require 'rspec'
require_relative '../../../services/application_service.rb'

RSpec.describe Transaction do
  after(:all) { Transaction.delete_all }
  describe 'Checks all the validations' do
    it 'throws error for empty transaction amount' do
      transaction = Transaction.new
      transaction.save
      expect(transaction.errors[:transaction_amount].present?)
        .to be(true)
      expect(transaction.errors[:transaction_amount].first)
        .to eq("can't be blank")
    end

    it 'throws error for empty merchant amount' do
      transaction = Transaction.new
      transaction.save
      expect(transaction.errors[:merchant_amount].present?).to be(true)
      expect(transaction.errors[:merchant_amount].first)
        .to eq("can't be blank")
    end

    it 'throws error for empty status' do
      transaction = Transaction.new
      transaction.save
      expect(transaction.errors[:status].present?).to be(true)
      expect(transaction.errors[:status].first)
        .to eq("can't be blank")
    end

    it 'throws error for transaction amount < 0' do
      transaction = Transaction.new(transaction_amount: (-100_000..0).to_a.sample)
      transaction.save
      expect(transaction.errors[:transaction_amount].present?).to be(true)
      expect(transaction.errors[:transaction_amount].first)
        .to eq('must be greater than 0')
    end
  end

  describe 'Processes transaction correctly' do
    it 'accepts transaction if amount > 0' do
      transaction = Transaction.new(transaction_amount: (1..1_000_000).to_a.sample)
      transaction.save
      expect(transaction.errors[:transaction_amount].present?).to be(false)
    end

    it 'correctly calculates merchant amount' do
      merchant = Merchant.create(
        name: 'm2',
        email: 'xyz@abc.com',
        discount_percentage: 5.0
      )
      merchant.reload

      user =  User.create(
        name: 'user1',
        email: 'qwez@abc.com',
        credit_limit: (1000..25_000).to_a.sample
      )
      user.reload

      transaction = Transaction.new(
        user_id: user.id,
        merchant_id: merchant.id,
        transaction_amount: 100
      )
      transaction.process_merchant_amount(merchant.discount_percentage)
      transaction.success.save

      transaction.reload
      expect(transaction.merchant_amount).to eq(95)
    end
  end

  describe 'Associations' do
    it 'correctly associates with merchant and user' do
      transaction = Transaction.first
      expect(transaction.user.present?).to be(true)
      expect(transaction.merchant.present?).to be(true)
    end
  end
end
