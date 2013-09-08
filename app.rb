require 'redis'
require 'bundler'
Bundler.require

# Creates a new instance of Redis
redis = Redis.new

# Define Sinatra helpers
helpers do
  include Rack::Utils
  alias_method :h, :escape_html

  def random_str(length)
    rand(36**length).to_s(36)
  end
end

# Configuration
set :environment, :production
set :port, 80

# Defines routes
get '/' do
  erb :index
end

post '/' do
  if params[:url] and not params[:url].empty?
    @code = random_str 5
    redis.setnx "links:#{@code}", params[:url]
  end
  erb :index
end

get '/:code' do
  @url = redis.get "links:#{params[:code]}"
  redirect @url || ''
end