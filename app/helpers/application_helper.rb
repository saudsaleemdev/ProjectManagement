module ApplicationHelper
  def edit_link(resource, name = 'Edit')
    link_to name, [:edit, resource], class: 'edit-link'
  end

  def delete_link(resource, name = 'Delete')
    link_to name, resource, class: 'text-danger font-weight-bold', method: :delete, data: {confirm: 'Are you sure?'}
  end
end
