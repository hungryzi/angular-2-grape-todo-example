require 'roar/json/hal'
require 'roar/hypermedia'

module V1
  module TodoRepresenter
    include Roar::JSON::HAL
    include Roar::Hypermedia
    include Grape::Roar::Representer

    property :description
    property :complete

    link :self do |opts|
      request = Grape::Request.new(opts[:env])
      request.url
    end
  end
end
