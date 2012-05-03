class Chef::Provider::JsonFile < Chef::Provider::File
  def compare_content
    JSON.load(::File.read(@current_resource.path)) == @new_resource.content
  end

  def set_content
    unless compare_content
      backup @new_resource.path if ::File.exists?(@new_resource.path)
      ::File.open(@new_resource.path, "w") {|f| f.write(JSON.pretty_generate(@new_resource.content)) }
      Chef::Log.info("#{@new_resource} contents updated")
      @new_resource.updated_by_last_action(true)
    end
  end
end

class Chef::Resource::JsonFile < Chef::Resource::File
  attribute :content, :kind_of => Hash

  def initialize(name, run_context=nil)
    super
    @resource_name = :json_file
  end
end
