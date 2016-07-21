require 'sinatra/base'
require 'yaml'

module Happo
  class Server < Sinatra::Base
    configure do
      enable :static
      set :port, Happo::Utils.config['port']
    end

    helpers do
      def h(text)
        Rack::Utils.escape_html(text)
      end
    end

    get '/' do
      @config = Happo::Utils.config
      erb :index
    end

    get '/debug' do
      @config = Happo::Utils.config
      erb :debug
    end

    get '/review' do
      @snapshots = Happo::Utils.current_snapshots
      erb :review
    end

    get '/resource' do
      file = params[:file]
      if file.start_with? 'http'
        redirect file
      else
        send_file file
      end
    end

    get '/*' do
      config = Happo::Utils.config
      file = params[:splat].first
      if File.exist?(file)
        send_file file
      else
        config['public_directories'].each do |pub_dir|
          filepath = File.join(Dir.pwd, pub_dir, file)
          if File.exist?(filepath)
            send_file filepath
          end
        end
      end
    end

    run!
  end
end