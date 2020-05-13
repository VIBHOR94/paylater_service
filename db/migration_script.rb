# frozen_string_literal: true

def run_migrations
  Dir[File.join(Dir.pwd, 'db', 'migrations', '*.rb')].sort.each do |filename|
    puts "migrating - #{filename}"
    load(filename)
  end
end

#Run for development database
run_migrations

# Run for test database

ENV['SCRIPT'] = 'test'
run_migrations