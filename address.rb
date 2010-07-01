#!/usr/bin/ruby
# Jonathan D. Stott <jonathan.stott@gmail.com>
require 'sinatra'
require 'mongo'
require 'views'

configure do
  DB = Mongo::Connection.new('10.0.0.9').db('jon')
end

set :mustache, { :templates => 'templates' }

helpers do
  def addresses
    DB['addresses']
  end

  def clean_params(param_set=params)
    case param_set
    when Array
      param_set.each do |v|
        if Array === v or Hash === v
          clean_params(v)
        end
      end
      param_set.delete_if { |v| v.empty? or v =~ /\A\s*\z/ }
    when Hash
      param_set.each do |k, v|
        if Array === v or Hash === v
          clean_params(v)
        end
      end
      param_set.delete_if { |k, v| v.empty? or v =~ /\A\s*\z/ }
    else
      param_set
    end
  end
end

before do
  content_type :html, :charset => 'utf-8'
  cache_control :private, :no_cache
end

get '/' do
  @addresses = addresses.find({}, :fields => [:name, :page], :sort => [[:page, :asc]]).to_a
  mustache :index
end

get '/new' do
  @person = {}
  mustache :edit
end

get '/:page/edit' do
  @person = addresses.find_one(:page => params['page'])
  not_found unless @person
  p @person
  mustache :edit
end

post '/:page' do |page|
  # clean up the params
  params.delete_if { |k,v| !%w|person|.include?(k) }
  params['person'] and params['person'].delete_if { |k,v| !%w|name page numbers emails addresses|.include?(k) }
  clean_params


  p params
  redirect "/#{page}/edit"
end
