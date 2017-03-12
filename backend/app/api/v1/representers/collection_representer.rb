require 'roar/json/hal'
require 'roar/hypermedia'

module V1
  module CollectionRepresenter
    extend ActiveSupport::Concern

    included do
      include Roar::JSON::HAL
      include Roar::Hypermedia
      include Grape::Roar::Representer

      property :count
      property :total_pages

      link :self do |opts|
        request = Grape::Request.new(opts[:env])
        request.url
      end

      link :first do |opts|
        unless first_page?
          request = Grape::Request.new(opts[:env])
          request.url_with_merged_params(page: 1)
        end
      end

      link :prev do |opts|
        if prev_page
          request = Grape::Request.new(opts[:env])
          request.url_with_merged_params(page: prev_page)
        end
      end

      link :next do |opts|
        if next_page
          request = Grape::Request.new(opts[:env])
          request.url_with_merged_params(page: next_page)
        end
      end

      link :last do |opts|
        unless last_page?
          request = Grape::Request.new(opts[:env])
          request.url_with_merged_params(page: total_pages)
        end
      end
    end
  end
end
