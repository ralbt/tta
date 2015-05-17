require 'active_support'

class Hashtag < ActiveRecord::Base
  has_and_belongs_to_many :tweets

  def self.top_hashtags(params, filter_type)
    case filter_type
    when 'date_range'
      result = validate_and_filter_date_range(params)
      if result[:valid]
        hashtags = top_10_hashtags(hashtags_between_date(result[:start_date], result[:end_date]))
        {error: false, hashtags: hashtags}
      else
        {error: true, message: result[:message]}
      end
    when 'bounding_box'
      result = validate_and_filter_boundries(params)
      if result[:valid]
        hashtags = top_10_hashtags(hashtags_inside_bounding_box(result[:boundries]))
        {error: false, hashtags: hashtags}
      else
        {error: true, message: result[:message]}
      end
    when 'bounding_box_and_date'
      result = validate_and_filter_boundries(params)
      if result[:valid] && result.merge!(validate_and_filter_date_range(params))[:valid]
        hashtags = top_10_hashtags(hashtags_inside_bounding_box(boundries).where(tweets: {tweet_created_at: result[:start_date]..result[:end_date]}))
        {error: false, hashtags: hashtags}
      else
        {error: true, message: result[:message]}
      end
    end
  end

  private

  def self.validate_and_filter_date_range(params)
    start_date = params[:start_date].to_date rescue nil
    end_date = params[:end_date].to_date rescue nil
    result = {}
    if start_date && end_date
      if start_date <= end_date
        result.merge!(valid: true, start_date: start_date, end_date: end_date)
      else
        result.merge!( valid: false, start_date: start_date, end_date: end_date, message: "Invalid parameter: start date should be less than end date")
      end
    else
      result.merge!(valid: false)
      start_date.nil? ? result.merge!(message: "Invalid start date") : result.merge!(message: "Invalid end date")
    end
    result
  end

  def self.validate_and_filter_boundries(params)
    boundries = params.clone.inject({}){|h,(k,v)| h[k.to_sym] = v; h}.
                        slice(:bl_lat, :bl_long, :tr_lat, :tr_long)
    result = {}
    if boundries.values.all?{|val| val =~ /^\d*\.?\d*$/}
      result.merge!(valid: true, boundries: boundries)
    else
      result.merge!(valid: false, message: "Invalid parameters")
    end
    result
  end

  def self.hashtags_between_date(start_date, end_date)
    Hashtag.joins(:tweets).where(tweets: {tweet_created_at: start_date..end_date})
  end

  def self.hashtags_inside_bounding_box(boundry_coordinates)
    Hashtag.joins(:tweets).where.not(tweets: {latitude: nil, longitude: nil})
                         .where(["latitude >= ? and latitude <= ? and longitude >= ? and longitude <= ?",
                              boundry_coordinates[:tr_lat], boundry_coordinates[:bl_lat], boundry_coordinates[:tr_long], boundry_coordinates[:bl_long]
                            ])
  end

  def self.top_10_hashtags(hashtags)
    hashtags.group(:hashtag_id).order('count(*) desc').select('distinct hashtags.*').limit(10).map(&:tag)
  end

end
