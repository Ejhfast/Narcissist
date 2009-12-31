require 'twitter'
require 'pp'


def user_look(user)
  narcs = ['me', 'my', 'I', "I'm", "I'll", "mine"]
  narcs_hash = Hash.new(0)
  total = 0
  res = Twitter::Search.new.from(user).map {|x| x.text}
  if res.size == 0
    return 0
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
  users = Twitter::Search.new('twitter').map {|x| x.from_user}
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
  # Currently, not used for anything
  trends = Twitter::Trends.current
  people = Array.new
  topics = Twitter::Trends.current.map {|x| x.name}
    topics[0..1].each do |t|
      people = people + Twitter::Search.new(t).map{|x| [x.from_user,false]}
      people = people.uniq
    end
  pp people
  while people.size < 1000
      newp = Array.new
      people.each do |person|
        if person[1] == false
          pp person[0]
          pp Twitter.friend_ids(person[0])
          tem = Twitter.friend_ids(person[0]).map{|x| [Twitter.user(x).screen_name,false]}
          newp = newp + tem
          newp = newp.uniq
        end
      end
      people = people.map{|x| [x[0],true]} + newp
      people = people.uniq
      puts people.size
    end
end
  

