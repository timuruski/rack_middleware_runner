require_relative '../environment'
require 'sinatra'
require 'json'

class MonitorApp < Sinatra::Base
  get '/users' do
    JSON.dump({users: Users.all})
  end

  get '/reports/:id' do
    report_id = params.fetch('id')
    # current_user = request.env.fetch('rack.current_user')
    # if report = Reports.find_for_user(current_user, report_id)
    if report = Reports.find(report_id)
      JSON.dump({report: report})
    else
      not_found
    end
  end
end

run MonitorApp.new
