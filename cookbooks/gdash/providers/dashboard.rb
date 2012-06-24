require 'yaml'

def load_current_resource
  node.include_attribute "gdash::gdash"
  node.include_recipe "gdash::default"

  @dashboard_dir = ::File.join(node.gdash.templatedir,
                             new_resource.category,
                             new_resource.name)

  @dashboard_yaml = ::File.join(@dashboard_dir,"dash.yaml")
end

action :create do

  @dashboard_dir.sub("#{node.gdash.templatedir}/", '').split('/').inject([node.gdash.templatedir]){|memo,val|
    memo.push(::File.join(memo.last, val))
  }.each do |dir_path|
    directory dir_path do
      owner node.gdash.owner
      group node.gdash.group
      recursive true
      notifies :restart, resources(:service => 'gdash'), :delayed
    end
  end

  file @dashboard_yaml do
    owner node.gdash.owner
    group node.gdash.group
    content YAML.dump(
      :name => new_resource.display_name || new_resource.name,
      :description => new_resource.description
    )
  end

  new_resource.updated_by_last_action(true)

end

action :delete do

  directory @dashboard_dir do
    action :delete
  end

  file @dashboard_yaml do
    action :delete
  end

  new_resource.updated_by_last_action(true)

end
