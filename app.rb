require 'sinatra'

class App < Sinatra
  get '/orders/:id' do
    if order = OrderRepo.find(params[:id])
      JSON.dump order.to_json
    else
      not_found
    end
  end
end
