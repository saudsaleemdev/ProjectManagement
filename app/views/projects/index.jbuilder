json.projects do
  render partial: 'project', collection: @resources, as: resource
end
