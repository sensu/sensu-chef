
def notify_if_updated
  if new_resource.updated?
    new_resource.updated_by_last_action(true)
  end
end
