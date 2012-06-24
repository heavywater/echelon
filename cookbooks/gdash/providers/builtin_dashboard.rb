def load_current_resource
  node.include_recipe "gdash::scrub_builtins"
end

action :create do
  new_dash = {
    new_resource.category => {
      new_resource.name => {
        :description => new_resource.description,
        :graphs => {}
      }
    }
  }
  node.set[:gdash][:builtin_dashboards] = Chef::Mixin::DeepMerge.merge(
    node[:gdash][:builtin_dashboards],
    new_dash
  ).to_hash
end
