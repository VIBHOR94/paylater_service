# frozen_string_literal: true

require_relative '../db_initiation.rb'

class CreateUserTable < ActiveRecord::Migration[5.2]
  def up
    return if ActiveRecord::Base.connection.table_exists?(:users)

    create_table :users do |table|
      table.string :name
      table.string :email
      table.float :credit_limit
      table.timestamps
    end
  end

  def down
    drop_table :users if ActiveRecord::Base.connection.table_exists?(:users)
  end
end

# Create the table
CreateUserTable.migrate(:up)

# Drop the table
# CreateUserTable.migrate(:down)
