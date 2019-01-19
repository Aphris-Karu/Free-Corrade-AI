## capitol-database-object

### gives the bot the ability to look up the capitol city of any location

* Place the capitol-database-object.rive in the brain directory
* Install the schema in a postgresql database.
* Install the database data file

Uses the DB environment variables in the docker container for
*  DBNAME = name of the database
*  DBSRV = name of the server
*  DBPORT = port number
*  DBUSER = database user name
*  DBPASSWD = database user password

Note: You can edit the rivescript and set defaults for the variables if you are running standalone.

Runs on Linux requiring the perl DBI library.
