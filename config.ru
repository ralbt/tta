$:.unshift File.expand_path("./../lib", __FILE__)

require './config/environment'
require 'sinatra/base'
require 'tta'

use ActiveRecord::ConnectionAdapters::ConnectionManagement

run TTA
