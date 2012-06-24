
include_recipe 'gdash::scrub_builtins'

if(node[:gdash][:builtins])
  builtin_dashboards do
    dashboards node[:gdash][:builtins]
  end
end
