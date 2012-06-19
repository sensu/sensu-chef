class Chef::Provider::JsonFile < Chef::Provider::File
  def load_json(path)
    JSON.load(::File.read(path)) rescue nil
  end

  def dump_json(obj)
    JSON.pretty_generate(obj) + "\n"
  end

  def compare_content
    begin
      load_json(@current_resource.path) == @new_resource.content
    rescue
      false
    end
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
    assert_enclosing_directory_exists!
    set_content unless @new_resource.content.nil?
    if respond_to?('enforce_ownership_and_permissions')
      updated = @new_resource.updated_by_last_action? # Work around bug in Chef 0.10.10
      enforce_ownership_and_permissions
      @new_resource.updated_by_last_action(true) if updated
    else
      set_owner unless @new_resource.owner.nil?
      set_group unless @new_resource.group.nil?
      set_mode unless @new_resource.mode.nil?
    end
  end
end

class Chef::Resource::JsonFile < Chef::Resource::File
  attribute :content, :kind_of => Hash

  def initialize(name, run_context=nil)
    super
    @resource_name = :json_file
    @provider = Chef::Provider::JsonFile
  end
end
