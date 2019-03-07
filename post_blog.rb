require 'pg'
require 'time'

#Usage:
#DATABASE_URL=$(heroku config:get DATABASE_URL -a sdubinsky) ruby post_blog.rb $FILENAME [$tag1 $tag2...]
#DATABASE_URL=postgres://localhost:4567/sdubinskysite ruby post_blog.rb $FILENAME [$tag1 $tag2...]
$db_url = ENV['DATABASE_URL']
connection = PG.connect($db_url)

filename = ARGV[0]
$tags = ARGV[1..-1]
$title = File.basename(filename, ".*").gsub("_", " ").split(" ").join(" ")
$post = File.read(filename)
$now = Time.now.to_i
command = "INSERT INTO posts (title, post, tags, timestamp) VALUES ('#{$title}', '#{$post.gsub("'", "''")}', '#{$tags.join(", ")}', #{$now})"
connection.exec(command)
