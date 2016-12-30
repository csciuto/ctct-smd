require 'net/http'
require 'json'
require 'ctct_smd/ctct_smd_logger'
require 'ctct_smd/ctct_smd_config'

module CTCT_SMD
  class BaseJsonHttpClient
    
    def get(uri, request_body='{}')
      CTCT_SMD.logger.debug("GET #{uri.path}, #{request_body}")      
      response = Net::HTTP.start(uri.hostname, uri.port, use_ssl: true) do |http|
        req = Net::HTTP::Get.new(uri)
        req['Content-Type'] = 'application/json'
        http.request(req, request_body)
      end
      CTCT_SMD.logger.debug("#{response.code}\n#{response.body}")
      JSON.parse(response.body)
    end

    def post(uri, request_body='{}')
      CTCT_SMD.logger.debug("POST #{uri.path}, #{request_body}")
      response = Net::HTTP.start(uri.hostname, uri.port, use_ssl: true) do |http|
        req = Net::HTTP::Post.new(uri)
        req['Content-Type'] = 'application/json'
        http.request(req, request_body)
      end
      CTCT_SMD.logger.debug("#{response.code}\n#{response.body}")
      JSON.parse(response.body)
    end

  end
end
