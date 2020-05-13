# frozen_string_literal: true

require 'rspec'
require_relative '../../../models/user.rb'

RSpec.describe User do
  after(:each) { User.delete_all }
  describe 'Checks all the validations' do
    let(:alphabets) { ('a'..'z').to_a + ('A'..'Z').to_a }
    let(:non_alphabets) { (0..9).to_a + %w[+ _ $ %] }

    it 'throws error for empty name' do
      user = User.new
      user.save
      expect(user.errors[:name].present?).to be(true)
      expect(user.errors[:name].first).to eq("can't be blank")
    end

    it 'accepts valid name' do
      valid_name = alphabets.shuffle.join('')[0, 10]
      user = User.new(name: valid_name)
      user.save

      expect(user.errors[:name].present?).to be(false)
    end

    it 'throws error for invalid name' do
      invalid_name = (alphabets.sample(9) + [non_alphabets.sample.to_s])
                     .shuffle.join('') + alphabets.sample

      user = User.new(name: invalid_name)
      user.save

      expect(user.errors[:name].present?).to be(true)

      expect(user.errors[:name].first)
        .to eq("Invalid name #{invalid_name}")
    end

    it 'checks uniqueness of name' do
      valid_name = alphabets.shuffle.join('')[0, 10]
      user = User.create(
        name: valid_name,
        email: 'xyz@abc.com',
        credit_limit: (1..25_000).to_a.sample
      )

      user_two = User.create(
        name: valid_name,
        email: 'xyz1@abdc.com',
        credit_limit: (1..25_000).to_a.sample
      )

      expect(user.errors[:name].present?).to be(false)
      expect(
        user_two.errors[:name]
        .include?('has already been taken')
      )
        .to be(true)
    end

    it 'throws error for empty email' do
      user = User.new
      user.save

      expect(user.errors[:email].present?).to be(true)
      expect(user.errors[:email].first).to eq("can't be blank")
    end

    it 'accepts valid email' do
      valid_email = [
        'abc123@xyz.in',
        'wasw@afa.com',
        'aee121@fbs.co.in'
      ].sample

      user = User.new(email: valid_email)
      user.save

      expect(user.errors[:email].present?).to be(false)
    end

    it 'throws error for invalid email' do
      invalid_email = [
        'ab$&c123@xyz.in',
        'wasw*#@afa.com',
        '-(aee121@fbs.co.in'
      ].sample

      user = User.new(email: invalid_email)
      user.save

      expect(user.errors[:email].present?).to be(true)
      expect(user.errors[:email].first)
        .to eq("Invalid email #{invalid_email}")
    end

    it 'throws error for no credit limit' do
      user = User.new
      user.save
      expect(user.errors[:credit_limit].present?).to be(true)
      expect(user.errors[:credit_limit].first)
        .to eq("can't be blank")
    end

    it 'throws error for credit limit < 0' do
      user = User.new(credit_limit: -7.0)
      user.save
      expect(user.errors[:credit_limit].present?).to be(true)
      expect(user.errors[:credit_limit].first)
        .to eq('must be greater than or equal to 0')
    end

    it 'accepts credit limit > 0' do
      user = User.new(credit_limit: (0..100_000).to_a.sample)
      user.save
      expect(user.errors[:credit_limit].present?).to be(false)
    end

    it 'throws error for withdraw more than credit limit' do
      user = User.create(
        name: 'user1234',
        email: 'xyz@abc.com',
        credit_limit: (1000..10_000).to_a.sample
      )

      user.withdraw(user.credit_limit + 100)
    rescue StandardError => e
      expect(e.message).to eq('Insufficient credit to perform transaction')
    end
  end

  describe 'Methods' do
    it 'accepts payback amount' do
      user = User.create(
        name: 'user1234',
        email: 'xyz@abc.com',
        credit_limit: 7000
      )

      user.withdraw(400)
      user.payback(300)
      user.save
      user.reload

      expect(user.dues).to eq(100.to_f)
    end

    it 'set dues to 0.0' do
      user = User.create(
        name: 'user1',
        email: 'xyz@abc.com',
        credit_limit: (1..25_000).to_a.sample
      )

      expect(user.dues).to be(0.0)
    end

    it 'gives correct dues after withdraw' do
      user = User.create(
        name: 'user1234',
        email: 'xyz@abc.com',
        credit_limit: (1000..10_000).to_a.sample
      )

      user.withdraw(700)
      user.save
      user.reload

      expect(user.available_credit).to be((user.credit_limit - 700).to_f)
    end
  end
end
