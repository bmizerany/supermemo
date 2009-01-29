require 'rubygems'
require 'sinatra'
require 'sequel'

class Hash
  def slice(*keys)
    self.inject({}) { |m,(k,v)| m[k] = v if keys.include?(k); m }
  end
end

configure do
  DB = Sequel.connect(ENV["DATABASE_URI"] || "sqlite://dev.db")
  DB.create_table :entries do
    column :text, :string
  end
end

get '/c.css' do
  content_type 'text/css'
  sass :c
end

get '/' do
  haml :index
end

post '/p.js' do
  DB[:entries] << params.slice(:text)
end
