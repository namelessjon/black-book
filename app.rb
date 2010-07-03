#!/usr/bin/ruby
# Jonathan D. Stott <jonathan.stott@gmail.com>
require 'sinatra/base'
require 'mongo'
require 'hashidator'
require 'black_book/views'


module BlackBook
  class App < ::Sinatra::Base

    register Mustache::Sinatra
    set :mustache, proc {
      {
        :namespace => ::BlackBook,
        :templates => ::File.join(self.root || '.', 'black_book', 'templates'),
      }
    }
    set :name, 'BlackBook'
    set :collection, 'people'

    set :validator, Hashidator.new(
      'name'       => String,
      'page'       => String,
      'numbers'    => proc { |v| v.nil? ? true : [{'name' => String, 'number' => String } ] },
      'emails'     => proc { |v| v.nil? ? true : [{'name' => String, 'email'  => String } ] },
      'addresses'  => proc { |v| v.nil? ? true : [{'name' => String, 'address' => String, 'postcode' => String, 'country' => String  }  ] },
    )

    helpers do
      def people
        settings.mongo[settings.collection]
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
      @people = people.find({}, :fields => [:name, :page], :sort => [[:page, :asc]]).to_a
      mustache :index
    end

    get '/new' do
      @person = {}
      mustache :edit
    end

    get '/:page' do |page|
      @person = people.find_one(:page => page)
      not_found unless @person
      mustache :show
    end

    get '/:page/edit' do |page|
      @person = people.find_one(:page => page) || {'page' => page}
      mustache :edit
    end

    post '/:page' do |page|
      throw :halt, [400, "Need a person in there to hold addresses"] unless params['person'] and Hash === params['person']
      # clean up the params
      params.delete_if { |k,v| "person" != k }
      params['person'].delete_if { |k,v| !%w|name numbers emails addresses|.include?(k) }
      params['person']['page'] = page
      clean_params

      @person = people.find_one({:page => page}) || {}
      @person.merge!(params['person'])

      if settings.validator.validate(@person)
        people.save(@person)
        redirect "/#{page}"
      else
        mustache :edit
      end
    end

    post '/' do
      throw :halt, [400, "Need a person in there to hold addresses"] unless params['person'] and Hash === params['person']
      # clean up the params
      params.delete_if { |k,v| "person" != k }
      params['person'].delete_if { |k,v| !%w|name page numbers emails addresses|.include?(k) }
      clean_params

      @person = people.find_one({:page => params['page']}, :fields => [:_id]) || {}
      @person.merge!(params['person'])

      if settings.validator.validate(@person)
        people.save(@person)
        redirect "/#{@person['page']}"
      else
        mustache :edit
      end
    end
  end
end
