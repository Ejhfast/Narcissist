require 'rubygems'
require 'sinatra'
require 'tweetlook.rb'

get '/' do
  haml :landing
end

get '/mentions-of-self' do
  haml :mentions
end

get '/:user' do
  failed = false
  begin
    score = user_look( params[:user] )
    others = random_users()
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

