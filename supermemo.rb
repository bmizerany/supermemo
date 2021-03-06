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
    column :referrer, :string
  end unless DB.table_exists?(:entries)
end

get '/d' do
  env.inspect
end

get '/c.css' do
  content_type 'text/css'
  sass :c
end

get '/' do
  haml :index, :locals => { :entries => DB[:entries] }
end

post '/p' do
  p params.inspect
  DB[:entries] << x = params.slice("text", "referrer")
  haml :p
end
