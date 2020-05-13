# frozen_string_literal: true

require 'yaml'
require 'active_record'

currernt_directory = File.dirname(__FILE__)
db_config_path = "#{currernt_directory}/database.yaml"
db_config_file = File.open(db_config_path)
db_config = YAML.safe_load(db_config_file)

db_config['database'] = 'paylater_service_db_test' if ENV['SCRIPT'] == 'test'

db_config['username'] = ENV['paylater_service_username']
db_config['password'] = ENV['paylater_service_password']

ActiveRecord::Base.establish_connection(db_config)
