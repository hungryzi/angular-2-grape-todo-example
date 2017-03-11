module V1
  module Defaults
    extend ActiveSupport::Concern

    included do
      content_type :hal, 'application/hal+json'
      content_type :json, 'application/json'

      formatter :json, Grape::Formatter::Roar
      formatter :hal, Grape::Formatter::Roar

      default_format :hal

      helpers do
        def handle_invalid_record!(e)
          errors = e.record.errors.messages.map do |attr, messages|
            messages.map { |message| { attribute: attr, message: message } }
          end.flatten
          error!(
            { errors: errors, status_code: 422 },
            422
          )
        end

        def handle_validation_errors!(e)
          errors = e.errors.map do |k, v|
            { message: v.first, attribute: k.first }
          end
          error!(
            { errors: errors, status_code: 422 },
            422
          )
        end

        def handle_unexpected_errors!(e)
          raise e if Rails.env.development?

          error!(
            { errors: [{ message: 'Unexpected error happened on server' }], status_code: 500 },
            500
          )
          # TODO
          # error notification: Rollbar...
        end
      end

      rescue_from ActiveRecord::RecordInvalid, with: :handle_invalid_record!
      rescue_from Grape::Exceptions::ValidationErrors, with: :handle_validation_errors!
      rescue_from :all, with: :handle_unexpected_errors!
    end
  end
end
