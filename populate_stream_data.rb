$:.unshift File.expand_path("./../lib", __FILE__)

require './config/environment'
require 'tweetstream'

TweetStream.configure do |config|
  config.consumer_key       = 'xWYNSx4BQEgDHH08xEPYvA'
  config.consumer_secret    = 'DTrnQnozvXQaLXRYAa2s8frEcoCQzH8kfDKrIrA'
  config.oauth_token        = '165843695-41ZW9CPHz0KHxjkq0BBEWqoiWxiEk9d1cMEwG86w'
  config.oauth_token_secret = 'LBjSa0cLxirWYqviiZrUQGJN0xWIjv0Tx3Bf8qhhizE'
  config.auth_method        = :oauth
end

daemon = TweetStream::Daemon.new
daemon.on_inited do
  ActiveRecord::Base.connection.reconnect!
end

daemon.sample do |status|
  hashtags = status.hashtags.map(&:text)
  puts "Location ::: #{status.place.full_name}"
  t = Tweet.create( :message => status.text,
                    :location => status.place.full_name,
                    :tweet_created_at => status.created_at.to_datetime
                  )
  if hashtags.any?
    hashtags.each do |h|
      t.hashtags << Hashtag.where(tag: h).first_or_create(tag: h)
    end
  end
end
