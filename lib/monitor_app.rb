require 'sinatra'
require 'json'

class MonitorApp < Sinatra::Base
  configure do
    set :public_folder, File.expand_path('../../static', __FILE__)
    set :views, File.expand_path('../../views', __FILE__)
  end

  helpers do
    def entries
      entry_names = Entries.map { |path| '/entries/' + File.basename(path) }
      JSON.dump({entries: entry_names})
    end
  end

  get '/' do
    erb :index
  end

  get '/user_tokens' do
    content_type :json
    user_tokens = Users.all.map { |user| user.token }
    JSON.dump({tokens: user_tokens})
  end

  get '/entries' do
    content_type :json
    entry_names = Entries.map { |path| 'http://localhost:9293/entries/' + File.basename(path) }
    JSON.dump({entries: entry_names})
  end

end
