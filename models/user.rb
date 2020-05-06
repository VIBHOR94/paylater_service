# frozen_string_literal: true

require_relative './application_record.rb'

class User < ApplicationRecord
  self.table_name = 'users'
end
