module Sensu
  class JSONFile
    class << self
      def load_json(path)
        JSON.parse(File.read(path)) rescue Hash.new
      end

      def dump_json(raw_hash)
        JSON.pretty_generate(raw_hash) + "\n"
      end

      def to_mash(raw_hash)
        Mash.from_hash(raw_hash)
      end

      def compare_content(path, content)
        to_mash(load_json(path)) == to_mash(content)
      end
    end
  end
end
