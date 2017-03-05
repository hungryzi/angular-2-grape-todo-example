class API < Grape::API
  format :json

  get '/greeting' do
    present :greeting, 'Hello!'
  end
end
