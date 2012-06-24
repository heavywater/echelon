include_recipe 'gdash'

gdash_dashboard 'Base Metrics' do
  category 'Basic'
  description 'Simple dashboard'
end

gdash_dashboard_component 'metrics_received' do
  dashboard_name 'Base Metrics'
  dashboard_category 'Basic'
  vtitle 'Items'
  fields(
    :received => {
      :data => '*.*.*.metricsReceived',
      :alias => 'Metrics Received'
    }
  )
end

gdash_dashboard_component 'cpu' do
  dashboard_name 'Base Metrics'
  dashboard_category 'Basic'
  fields(
    :cpu => {
      :data => '*.*.*.cpuUsage',
      :alias => 'CPU Usage'
    }
  )
end

gdash_dashboard_component 'memory' do
  dashboard_name 'Base Metrics'
  dashboard_category 'Basic'
  fields(
    :memory => {
      :data => '*.*.*.memUsage',
      :alias => 'Memory Usage'
    }
  )
end
