class TTA < Sinatra::Base
  get '/top/hashtags/date_range/:start_date/:end_date' do
    Hashtag.top_hashtags(params, 'date_range').to_json
  end

  get '/top/hashtags/inside_bounding_box/:bl_lat/:bl_long/:tr_lat/:tr_long' do
    response = Hashtag.top_hashtags(params, 'bounding_box').to_json
  end

  get '/top/hashtags/inside_bounding_box/:bl_lat/:bl_long/:tr_lat/:tr_long/date_range/:start_date/:end_date' do
    response = Hashtag.top_hashtags(params, 'bounding_box_and_date').to_json
  end
end
