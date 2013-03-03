module SensuDefinitions
  class << self
    def sanitize(definition, options = {})
      # By default, don't remove levels of hierarchy (empty hashes) the code might expect
      options = {
        :master_keys => nil,
        :allow_empty_hash => true
      }.merge(options)
      sub_options = options.merge({:master_keys => nil})

      if definition.is_a?(Hash)
        new_definition = Mash.new
        definition.each do |key, value|
          if options[:master_keys].nil? || options[:master_keys].include?(key.to_s)
            new_value = sanitize(value, sub_options)
            new_definition[key] = new_value unless new_value.nil?
          end
        end
        if !new_definition.empty? || options[:allow_empty_hash]
          new_definition
        else
          nil
        end
      else
        definition
      end
    end
  end
end