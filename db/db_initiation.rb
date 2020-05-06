require 'yaml'
require 'active_record'

currernt_directory = File.dirname(__FILE__)
db_config_path = "#{currernt_directory}/database.yaml"
db_config_file = File.open(db_config_path)
db_config = YAML::load(db_config_file)

db_config["username"] = ENV["paylater_service_username"]
db_config["password"] = ENV["paylater_service_password"]

ActiveRecord::Base.establish_connection(db_config)