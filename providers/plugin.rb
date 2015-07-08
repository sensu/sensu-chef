def manage_sensu_asset(resource_action)
  attributes = Sensu::Helpers.select_attributes(
    new_resource,
    %w[
      cookbook source source_directory checksum
      path mode owner group rights
    ]
  )

  a = sensu_asset new_resource.name do
    asset_directory new_resource.asset_directory || ::File.join(node["sensu"]["directory"], "plugins")
    attributes.each do |key, value|
      send(key.to_sym, value)
    end
    action resource_action
  end

  new_resource.updated_by_last_action(a.updated_by_last_action?)
end

[
 :create,
 :create_if_missing,
 :delete
].each do |resource_action|
  action resource_action do
    manage_sensu_asset(resource_action)
  end
end
