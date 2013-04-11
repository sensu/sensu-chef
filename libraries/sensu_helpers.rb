module Sensu
  class Helpers
    class << self
      def select_attributes(attributes, keys)
        attributes.to_hash.reject do |key, value|
          !Array(keys).include?(key.to_s) || value.nil?
        end
      end

      def sanitize(hash)
        sanitized = Hash.new
        hash.each do |key, value|
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
    end
  end
end
