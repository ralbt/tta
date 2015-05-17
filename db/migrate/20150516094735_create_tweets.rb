class CreateTweets < ActiveRecord::Migration
  def change
    create_table :tweets do |t|
      t.string :message
      t.string :location
      t.float :latitude, index: true
      t.float :longitude, index: true
      t.datetime :tweet_created_at, index: true
    end
  end
end
