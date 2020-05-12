# Paylater Service App

A simple command line application to handle user, merchant and transactions for paylater service. Using this apllication, new users and merchants can be created where user is issued some credit limit using which s/he can perform a transaction for a registered mechant.

Dependencies -

* Postgresql database

### Installing

* Create a database named paylater_service_db

* Create/Assign a user with access to this database

* Run the following in your Terminal -

   * `export paylater_service_username=${database_user}`
   * `export paylater_service_password=${database_password}`

* Replace ${database_user} with database user name and ${database_password} with password.

* Run `bundle install`

* Run `ruby db/migration_script.rb`

* Run `ruby initialize.rb` to start the application.
