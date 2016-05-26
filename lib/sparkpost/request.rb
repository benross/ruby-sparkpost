require 'net/http'
require 'json'

require_relative 'version'
require_relative 'exceptions'

# return Net::HTTP.get(domain, "#{path}?".concat(params.collect { |k,v| "#{k}=#{CGI::escape(v.to_s)}" }.join('&'))) if not params.nil?
module SparkPost
  module Request
    def request(url, api_key, data, verb = 'POST')
      uri = URI.parse(url)
      http = configure_http(uri)
      headers = {
        'User-Agent' => 'ruby-sparkpost/' + VERSION,
        'Content-Type' => 'application/json',
        'Authorization' => api_key
      }
      req = configure_request(uri, headers, data, verb)
      process_response(http.request(req))
    end

    def endpoint(subpath = nil, params = {})
      url = String.new(@base_endpoint)
      if subpath
        url << '/' unless subpath.start_with?('/')
        url << subpath
      end
      if params && params.any?
        url << '?'
        url << params.to_a.map { |x| "#{x[0]}=#{x[1]}" }.join('&')
      end
      url
    end

    def configure_http(uri)
      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = true
      http
    end

    def configure_request(uri, headers, data, verb)
      req = case verb
            when 'GET'
              Net::HTTP::Get.new(uri, headers)
              # Net::HTTP::Get.new(uri.path, headers)
            when 'PUT'
              Net::HTTP::Put.new(uri.path, headers)
            when 'DELETE'
              Net::HTTP::Delete.new(uri.path, headers)
            else
              Net::HTTP::Post.new(uri.path, headers)
            end
      req.body = JSON.generate(data) if data.present?
      req
    end

    def process_response(response)
      response = JSON.parse(response.body) unless response.body.nil?
      if response['errors']
        raise SparkPost::DeliveryException, response['errors']
      else
        response['results']
      end
    end

    module_function :request, :configure_http, :configure_request,
                    :process_response
  end
end
