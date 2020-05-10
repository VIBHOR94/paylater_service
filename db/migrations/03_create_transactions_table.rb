# frozen_string_literal: true

require_relative '../db_initiation.rb'

class CreateTransactionsTable < ActiveRecord::Migration[5.2]
  def up
    return if ActiveRecord::Base.connection.table_exists?(:transactions)

    create_table :transactions do |table|
      table.float :transaction_amount
      table.float :merchant_amount
      table.string :status
      table.timestamps
    end
    add_reference :transactions, :user, index: true
    add_foreign_key :transactions, :users

    add_reference :transactions, :merchant, index: true
    add_foreign_key :transactions, :merchants
  end

  def down
    return unless ActiveRecord::Base.connection.table_exists?(:transactions)

    drop_table :transactions
  end
end

# Create the table
CreateTransactionsTable.migrate(:up)

# Drop the table
# CreateTransactionsTable.migrate(:down)
