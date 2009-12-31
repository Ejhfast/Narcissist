gem('twitter4r', '>=0.2.0')
require('twitter')
require 'pp'


def user_look(user)
  narcs = ['me', 'my', 'I', "I'm", "I'll", "mine"]
  narcs_hash = Hash.new(0)
  total = 0
  client = Twitter::Client.new(:login => 'user', :password => 'password')
  res = client.timeline_for(:user, :id => user, :count => 50).map {|x| x.text}
  if res == nil
    raise Error
  end
  res.each do |r|
  	#puts r + "\n\n"
  	(0..r.size).each do |idx|
  		narcs.each do |n|
  			if(r[idx..idx+n.size-1] == n)
  			  if r[idx+n.size] == ' '
  				  narcs_hash[n] = narcs_hash[n] + 1
				  end
  			end
  		end
  	end
  end
  narcs_hash.keys.each do |key|
	  total = total + narcs_hash[key]
	  #puts "#{key}: #{narcs_hash[key]}"
  end
  tweet_to_self = total.to_f / res.size.to_f
  #puts "Tweet to Self Ratio: #{tweet_to_self}"
  tweet_to_self
end

def random_users()
  user_hash = Hash.new(0)
  client = Twitter::Client.new(:login => 'NarcTweet1', :password => 'mypass1')
  users = client.timeline_for(:public).map {|x| x.user.screen_name}
  users[0..2].each do |u|
  	user_hash[u] = user_look(u)
  	puts "#{u}: #{user_hash[u]}"
  end
  user_hash
end

def average_score(user_hash)
  avg = 0
  user_hash.keys.each do |key|
  	avg = avg + user_hash[key]
  end
  avg = avg / user_hash.keys.size
  puts "Average: #{avg}"
  avg
end

def long_average()
  hash = Hash.new(0)
  (0..5).each do
    tem = random_users()
    pp tem
    hash = hash.merge(tem)
    pp hash
  end
  pp hash
  puts average_score(hash)
end

  

