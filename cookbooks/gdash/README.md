Description
===========

Cookbook to automatically deploy the Gdash web interface for
Graphite.

Requirements
============

## Platform:

 * Debian/Ubuntu

## Cookbooks

 * build-essentials
 * runit

Attributes
==========

 See `attributes/default.rb` for defaults.

 * `node['gdash']['graphite_whisperdb']` - Full path to graphite
   database
 * `node['gdash']['templatedir']` - Full path to graph templates

Usage
=====

This cookbook currently sets up gdash and a basic runit service.
Graph creation is left to the user.

Graph Creation
==============

Dashboard creation
------------------

First create a dashboard:

```ruby

gdash_dashboard 'cpu_usage' do
  category 'metrics'
  description 'CPU Usages'
end
```

Dashboard component creation
----------------------------

Next, add components to the dashboard. Dashboards are referenced by
their name and category when adding components:

```ruby

gdash_dashboard_component 'node1' do
  dashboard_name 'cpu_usage'
  dashboard_category 'metrics'
  linemode 'slope'
  description 'Node1 CPU usage'
  fields(
    :system => {
      :scale => 0.001,
      :color => 'orange',
      :alias => 'System Usage 0',
      :data => 'node1.cpu.0.system.value'
    },
    :user => {
      :scale => 0.001,
      :color => 'blue',
      :alias => 'User Usage 0',
      :data => 'node1.cpu.0.user.value'
    }
  )
end
```

