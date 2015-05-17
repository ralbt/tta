class CreateHashtagsTweets < ActiveRecord::Migration
  def change
    create_table :hashtags_tweets, id: false do |t|
      t.integer :tweet_id, index: true
      t.integer :hashtag_id, index: true
    end
  end
end
