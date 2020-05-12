Setting up Application -

Dependencies -

* Postgresql database

Steps -

* Create a database named paylater_service_db

* Create/Assign a user with access to this database

* Run the following in your Terminal -

   * `export paylater_service_username=${database_user}`
   * `export paylater_service_password=${database_password}`

* Run `bundle install`

* Run `ruby db/migration_script.rb`

* Run `ruby initialize.rb` to start the application.