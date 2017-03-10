require 'roar/json/hal'
require 'roar/hypermedia'

module V1
  module TodosRepresenter
    include Roar::JSON::HAL
    include Roar::Hypermedia
    include Grape::Roar::Representer

    collection :entries, extend: TodoRepresenter, as: :todos, embedded: true

    link :self do |opts|
      request = Grape::Request.new(opts[:env])
      request.url
    end
  end
end
