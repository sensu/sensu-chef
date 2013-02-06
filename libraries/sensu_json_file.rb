module SensuJsonFile
  class << self
    def load_json(path)
      JSON.parse(File.read(path)) rescue Hash.new
    end

    def dump_json(obj)
      JSON.pretty_generate(obj) + "\n"
    end

    def to_mash(obj)
      Mash.from_hash(obj)
    end

    def compare_content(path, content)
      to_mash(load_json(path)) == to_mash(content)
    end
  end
end
