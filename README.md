## deploy
* heroku login
* heroku create [NAME]
* git push heroku master
* heroku config:set READER_SERVER_PRODUCTION_DATABASE_URL=mongodb://username:password@host:port/database
* heroku run ruby db/seeds.rb

## api
* http://example.com/api/channels
* http://example.com/api/items