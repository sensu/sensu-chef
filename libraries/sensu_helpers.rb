module Sensu
  class Helpers
    class << self
      def select_attributes(resource, keys)
        resource.to_hash.reject do |key, value|
          !Array(keys).include?(key.to_s) || value.nil?
        end
      end

      def sanitize(hash)
        sanitized = Hash.new
        hash.each do |key, value|
          case value
          when Hash
            sanitized[key] = sanitize(value)
          when nil
            # noop
          else
            sanitized[key] = value
          end
        end
        sanitized
      end
    end
  end
end
