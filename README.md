# TTA

The following are the steps to run the app:

* Create database called **tta** (mysql).
* Run `ruby populate_stream_data.rb start` to collect data from twitter sample stream
* Start server: `rackup`

# Apis

* /top/hashtags/date_range/:start_date/:end_date
* /top/hashtags/inside_bounding_box/:bl_lat/:bl_long/:tr_lat/:tr_long
* /top/hashtags/inside_bounding_box/:bl_lat/:bl_long/:tr_lat/:tr_long/date_range/:start_date/:end_date
