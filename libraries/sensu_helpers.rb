require "openssl"

module Sensu
  class Helpers
    class << self
      def select_attributes(attributes, keys)
        attributes.to_hash.reject do |key, value|
          !Array(keys).include?(key.to_s) || value.nil?
        end
      end

      def sanitize(raw_hash)
        sanitized = Hash.new
        raw_hash.each do |key, value|
          # Expand Chef::DelayedEvaluator (lazy)
          value = value.call if value.respond_to?(:call)

          case value
          when Hash
            sanitized[key] = sanitize(value) unless value.empty?
          when nil
            # noop
          else
            sanitized[key] = value
          end
        end
        sanitized
      end

      def gem_binary
        if File.exists?("/opt/sensu/embedded/bin/gem")
          "/opt/sensu/embedded/bin/gem"
        else
          "gem"
        end
      end

      def data_bag_item(item, missing_ok=false)
        raw_hash = Chef::DataBagItem.load("sensu", item)
        encrypted = raw_hash.detect do |key, value|
          if value.is_a?(Hash)
            value.has_key?("encrypted_data")
          end
        end
        if encrypted
          secret = Chef::EncryptedDataBagItem.load_secret
          Chef::EncryptedDataBagItem.new(raw_hash, secret)
        else
          raw_hash
        end
      rescue Chef::Exceptions::ValidationFailed,
        Chef::Exceptions::InvalidDataBagPath,
        Net::HTTPServerException => error
        missing_ok ? nil : raise(error)
      end

      def random_password(length=20)
        password = ""
        while password.length < length
          password << ::OpenSSL::Random.random_bytes(1).gsub(/\W/, '')
        end
        password
      end
    end
  end
end
