require 'rubygems'
require 'sinatra'
require 'twitter'
require 'tweetlook.rb'

template :no_exist do
  '%h2 Alas, the queried user does not exist.'
end

get '/:user' do
  score = user_look( params[:user] )
  others = random_users()
  average = average_score(others)
  ratio = score / average
  if ratio < 1
    message = "Quite Modest"
  elsif ratio == 1
    message = "Rather Average"
  elsif ratio > 1 and ratio < 2
    message = "Self-Important"
  else
    message = "a Raging Ego"
  end
  if Twitter.user( params[:user] ).error == nil
    puts 'hello'
    haml :index, :locals => {
                            :user => params[:user], :number => score, 
                            :sample => others, :average => average, :message => message }
  else
    haml :no_exist
  end
end