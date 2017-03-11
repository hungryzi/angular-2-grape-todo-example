require 'grape-swagger'
require_relative './representers/todo_representer'

module V1
  class Api < Grape::API
    version 'v1', using: :path

    content_type :json, 'application/json'
    content_type :hal_json, 'application/hal+json'

    formatter :json, Grape::Formatter::Roar
    formatter :hal_json, Grape::Formatter::Roar

    default_format :hal_json

    mount TodosApi

    add_swagger_documentation \
      info: {
        title: 'The API title to be displayed on the API homepage.',
        description: 'A description of the API.',
        contact_name: 'hungryzi',
        contact_email: 'hungryzi (at) gmail.com',
        contact_url: 'hungryzi.com',
        license: 'MIT',
        license_url: 'www.The-URL-of-the-license.org',
        terms_of_service_url: 'www.The-URL-of-the-terms-and-service.com'
      }
  end
end
