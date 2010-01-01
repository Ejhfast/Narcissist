require 'rubygems'
require 'sinatra'
require 'tweetlook.rb'
require 'sqlwrap.rb'

conditional_up()

def random_users_db(tweeters)
	others = tweeters.sort_by{|x| rand(100)}.first(3)
	hash = Hash.new(0)
	others.each do |person|
		hash[person[:user]] = person[:narcQuo]
	end
	hash	
end

get '/' do
  haml :landing
end

get '/mentions-of-self' do
  haml :mentions
end

get '/:user' do
  tweeters = DB[:tweeters]
  failed = false
  begin
	req = tweeters.filter(:user => params[:user]).order(:created_at).last
	if req != nil and req[:created_at] >= Time.now - 3600
		score = req[:narcQuo]
	else
    	score = user_look( params[:user] )
		tweeters.insert(:user => params[:user], :narcQuo => score, 
						:created_at => Time.now)
    end
	others = random_users_db(tweeters)
    average = 0.355947523810431 # hard coded from previous data collection
    ratio = score / average
  rescue
    failed = true
  end
  if failed != true
    if ratio < 1
      message = "Quite Modest"
    elsif ratio == 1
      message = "Rather Average"
    elsif ratio > 1 and ratio < 2
      message = "Self-Important"
    else
      message = "a Raging Ego"
    end
    haml :index, :locals => {
                            :user => params[:user], :number => score, 
                            :sample => others, :average => average, :message => message }
  else
    haml :no_exist
  end
end

