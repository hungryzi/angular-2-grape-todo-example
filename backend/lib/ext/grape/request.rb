module Grape
  class Request
    def url_with_merged_params(new_params)
      base_url + path + merged_query_string(new_params)
    end

    private

    def merged_query_string(new_params)
      new_params = extend_params(new_params)
      if new_params.empty?
        nil
      else
        query = new_params.map do |k, v|
          "#{k}=#{v}"
        end.join('&')
        "?#{query}"
      end
    end

    def extend_params(new_params)
      params.clone.merge(new_params)
    end
  end
end
