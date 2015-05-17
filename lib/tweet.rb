require 'geocoder/railtie'
Geocoder::Railtie.insert

class Tweet < ActiveRecord::Base
  has_and_belongs_to_many :hashtags
  geocoded_by :location
  after_validation :geocode

end
