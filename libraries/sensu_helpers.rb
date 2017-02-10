require "openssl"

module Sensu
  class Helpers
    extend ChefVaultCookbook if Kernel.const_defined?("ChefVaultCookbook")
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
        elsif File.exists?('c:\opt\sensu\embedded\bin\gem.bat')
          'c:\opt\sensu\embedded\bin\gem.bat'
        else
          "gem"
        end
      end

      def data_bag_item(item, missing_ok=false, data_bag_name="sensu")
        raw_hash = Chef::DataBagItem.load(data_bag_name, item).delete_if { |k,v| k == "id" }
        encrypted = raw_hash.detect do |key, value|
          if value.is_a?(Hash)
            value.has_key?("encrypted_data")
          end
        end
        if encrypted
          if Chef::DataBag.load(data_bag_name).key? "#{item}_keys"
            chef_vault_item(data_bag_name, item)
          else
            secret = Chef::EncryptedDataBagItem.load_secret
            Chef::EncryptedDataBagItem.new(raw_hash, secret)
          end
        else
          raw_hash
        end
      rescue Chef::Exceptions::ValidationFailed,
        Chef::Exceptions::InvalidDataBagPath,
        Net::HTTPServerException => error
        missing_ok ? nil : raise(error)
      end

      def random_password(length=20, number=false, upper=false, lower=false, special=false)
        password = ""
        requiredOffset = 0
        requiredOffset += 1 if number
        requiredOffset += 1 if upper
        requiredOffset += 1 if lower
        requiredOffset += 1 if special
        length = requiredOffset if length < requiredOffset
        limit = password.length < (length - requiredOffset)

        while limit || requiredOffset > 0
          push = false
          c = ::OpenSSL::Random.random_bytes(1).gsub(/\W/, '')
          if c != ""
            if c =~ /[[:digit:]]/
              requiredOffset -= 1 if number
              number = false
            elsif c >= 'a' && c <= 'z'
              requiredOffset -= 1 if lower
              lower = false
            elsif c >= 'A' && c <= 'Z'
              requiredOffset -= 1 if upper
              upper = false
            else
              requiredOffset -= 1 if special
              special = false
            end
          end
          limit = password.length < (length - requiredOffset)
          if limit
            password << c
          end
        end
        password
      end

      # Wraps the Chef::Util::Windows::NetUser, returning false if the Win32 constant
      # is undefined, or returning false if the user does not exist. This indirection
      # seems like the most expedient way to make the sensu::_windows recipe testable
      # via chefspec on non-windows platforms.
      #
      # @param [String] the name of the user to test for
      # @return [TrueClass, FalseClass]
      def windows_user_exists?(user)
        if defined?(Win32)
          net_user = Chef::Util::Windows::NetUser.new(user)
          !!net_user.get_info rescue false
        else
          false
        end
      end

      # Wraps Win32::Service, returning false if the Win32 constant
      # is undefined, or returning false if the user does not exist. This indirection
      # seems like the most expedient way to make the sensu::_windows recipe testable
      # via chefspec on non-windows platforms.
      #
      # @param [String] the name of the service to test for
      # @return [TrueClass, FalseClass]
      def windows_service_exists?(service)
        if defined?(Win32)
          ::Win32::Service.exists?(service)
        else
          false
        end
      end

      # Derives Sensu package version strings for Redhat platforms.
      # When the desired Sensu version is '0.27.0' or later, the package
      # requires a '.elX' suffix.
      #
      # @param [String] Sensu version string
      # @param [String] Platform version
      # @param [String,NilClass] Suffix to override default '.elX'
      def redhat_version_string(sensu_version, platform_version, suffix_override = nil)
        bare_version = sensu_version.split('-').first
        if Gem::Version.new(bare_version) < Gem::Version.new('0.27.0')
          sensu_version
        else
          platform_major = Gem::Version.new(platform_version).segments.first
          suffix = suffix_override || ".el#{platform_major}"
          [sensu_version, suffix].join
        end
      end

    end
  end
end
