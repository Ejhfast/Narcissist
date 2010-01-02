require 'rubygems'
require 'sequel'

DB = Sequel.connect('sqlite://twitterers.db')

def conditional_up()
	if not DB.table_exists? :tweeters
		up
	end
end

def up
	DB.create_table :tweeters do
		primary_key :id
		String :user
		Float	:narcQuo
		Time	:created_at
	end
end

def down
	DB.drop_table :tweeters
end 
