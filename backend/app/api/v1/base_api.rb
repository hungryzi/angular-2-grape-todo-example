module V1
  class BaseApi < Grape::API
    version 'v1', using: :path
    formatter :json, Grape::Formatter::Roar

    mount TodosApi
  end
end
