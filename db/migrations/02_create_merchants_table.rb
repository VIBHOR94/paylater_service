# frozen_string_literal: true

load 'db/db_initiation.rb'

class CreateMerchantsTable < ActiveRecord::Migration[5.2]
  def up
    return if ActiveRecord::Base.connection.table_exists?(:merchants)

    create_table :merchants do |table|
      table.string :name
      table.string :email
      table.float :discount_percentage
      table.timestamps
    end
  end

  def down
    return unless ActiveRecord::Base.connection.table_exists?(:merchants)

    drop_table :merchants
  end
end

# Create the table
CreateMerchantsTable.migrate(:up)

# Drop the table
# CreateMerchantsTable.migrate(:down)
