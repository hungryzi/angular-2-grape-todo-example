class ApplicationApi < Grape::API
  format :json

  mount V1::BaseApi

  get '/greeting' do
    present :greeting, 'Hello!'
  end
end
