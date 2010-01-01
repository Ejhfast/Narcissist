gem('twitter4r', '>=0.2.0')
require('twitter')
require('pp')


def user_look(user)
  arr = File.new('password').to_a
  the_user = arr[0]
  the_pass = arr[1]
  narcs = ['me', 'my', 'I', "I'm", "I'll", "mine"]
  narcs_hash = Hash.new(0)
  total = 0
  client = Twitter::Client.new(:login => the_user, :password => the_pass)
  res = client.timeline_for(:user, :id => user, :count => 50).map {|x| x.text}
  if res == nil
    raise Error
  end
  res.each do |r|
    words = r.split(' ')
    narcs.each do |n|
      num = words.select{|x| x == n}.size
      narcs_hash[n] = narcs_hash[n] + num
    end
  end
  narcs_hash.keys.each do |key|
	  total = total + narcs_hash[key]
  end
  tweet_to_self = total.to_f / res.size.to_f
end

def random_users()
  arr = File.new('password').to_a
  the_user = arr[0]
  the_pass = arr[1]
  user_hash = Hash.new(0)
  client = Twitter::Client.new(:login => the_user, :password => the_pass)
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

  

