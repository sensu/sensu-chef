require 'uri'
require 'net/http'
require 'json'

module Sensu
  class API
    class Stash
      def initialize(api_uri)
        @server_uri = URI(api_uri)
      end

      def get(path)
        req = Net::HTTP::Get.new(path)
        response = Net::HTTP.start(@server_uri.host, @server_uri.port) do |http|
          http.request(req)
        end

        case response.code
        when '200'
          # stash exists, so load the response body into @current_resource.payload
          # but omit the timestamp; @new_resource.timestamp should always differ
          body = JSON.parse(response.body)
          body.reject { |key, value| key == 'timestamp' }
        when '404'
          false
        when '500'
          Chef::Log.fatal "Sensu::API::Stash: Error getting #{path} from #{api_uri}: " + response.body.inspect
          raise
        end
      end

      def post(path, payload={})
        req = Net::HTTP::Post.new(path, {'Content-Type'=>'application/json'})

        req.body = payload.to_json

        response = Net::HTTP.start(@server_uri.host, @server_uri.port) do |http|
          http.request(req)
        end

        case response.code
        when '201'
          Chef::Log.debug "Sensu::API::Stash: Successfully stashed payload to #{path} on #{@server_uri}: " + payload.inspect
        when '400'
          Chef::Log.fatal "Sensu::API::Stash: Malformed payload for #{path} on #{@server_uri}: " + payload.inspect
        when '500'
          Chef::Log.fatal "Sensu::API::Stash: Error stashing payload to #{path} on #{@server_uri}: " + response.inspect
        end
      end

      def delete(path)
        req = Net::HTTP::Delete.new(path)
        response = Net::HTTP.start(@server_uri.host, @server_uri.port) do |http|
          http.request(req)
        end

        case response.code
        when '204'
          Chef::Log.debug "Sensu::API::Stash: Successfully deleted stash #{path} on #{@server_uri}."
        when '404'
          Chef::Log.debug "Sensu::API::Stash: Could not delete stash #{path} on #{@server_uri}, as it does not exist."
        when '500'
          Chef::Log.fatal "Sensu::API::Stash: Error deleting stash #{path} on #{@server_uri}: " + response.body.inspect
        end
      end
    end
  end
end
