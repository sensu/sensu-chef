class Chef::Provider::JsonFile < Chef::Provider::File
  def load_json(path)
    JSON.load(::File.read(path)) rescue nil
  end

  def dump_json(obj)
    JSON.pretty_generate(obj) + "\n"
  end

  def compare_content
    load_json(@current_resource.path) == @new_resource.content
  end

  def set_content
    unless compare_content
      backup @new_resource.path if ::File.exists?(@new_resource.path)
      ::File.open(@new_resource.path, "w") {|f| f.write dump_json(@new_resource.content) }
      Chef::Log.info("#{@new_resource} updated file #{@new_resource.path}")
      @new_resource.updated_by_last_action(true)
    end
  end

  def action_create
    set_content unless @new_resource.content.nil?
    set_owner unless @new_resource.owner.nil?
    set_group unless @new_resource.group.nil?
    set_mode unless @new_resource.mode.nil?
  end
end

class Chef::Resource::JsonFile < Chef::Resource::File
  attribute :content, :kind_of => Hash

  def initialize(name, run_context=nil)
    super
    @resource_name = :json_file
  end
end
