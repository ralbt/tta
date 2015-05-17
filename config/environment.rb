require 'sinatra'
require 'sinatra/activerecord'
require 'geocoder'
require 'geocoder/railtie'
require 'json'
require 'tweet'
require 'hashtag'

set :database, { :adapter => "mysql2",
                 :host => "localhost",
                 :username => "root",
                 :password => "root",
                 :database => "tta"
               }
