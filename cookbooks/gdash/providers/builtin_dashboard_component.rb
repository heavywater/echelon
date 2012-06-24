def load_current_resource
  node.include_recipe "gdash::scrub_builtins"
end

action :create do
  component = new_resource.params.dup
  [:dashboard_category, :dashboard_name, :name].each do |key|
    component.delete(key)
  end
  graph_hash = (::GDASH_RESOURCE_ATTRIBS + %w(fields forecasts)).map{ |attr|
    if(new_resource.respond_to?(attr) && !new_resource.send(attr).nil?)
      [attr, new_resource.send(attr)]
    else
      nil
    end
  }.compact.flatten
  graph_hash = Hash[*graph_hash]
  new_dash = {
    new_resource.dashboard_category => {
      new_resource.dashboard_name => {
        :graphs => {
          new_resource.name => graph_hash
        }
      }
    }
  }
  node.set[:gdash][:builtin_dashboards] = Chef::Mixin::DeepMerge.merge(
    node[:gdash][:builtin_dashboards].to_hash,
    new_dash
  ).to_hash
end
