#
# Cookbook Name:: gdash
# Recipe:: graph_generator
#
# Copyright 2012, Sean Escriva <sean.escriva@gmail.com>
# Copyright 2012, AJ Christensen <aj@junglist.gen.nz>
# Copyright 2012, Chris Roberts <chrisroberts.code@gmai.com>
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

include_recipe "gdash::default"
=begin
{
  'Category Name' => {
    'Dashboard Name 1' => {
      :description => 'Some Description',
      :graphs => {
        'Metrics Received' => {
          :vtitle => 'metrics',
          :fields => {
            :received => {
              :data => '*.*.*.metricsReceived',
              :alias => 'Metrics'
            }
          }
        }
      }
    }
  }
}
=end

# Attribute based dashboard building
dashboard_groups = [node[:gdash][:dashboards]]
# Node discovery based dashboard building
unless Chef::Config['solo']
  nodes = search(:node, node[:gdash][:discovery_pattern]).find_all{|n| n[:gdash] && n[:gdash][:builtin_dashboards]}
  dashboard_groups += nodes.map{|n| n[:gdash][:builtin_dashboards]}

  dashboard_groups.compact.each do |board|
    board.each_pair do |category_name, category_items|
      category_items.each do |dash_name, dash_contents|
        gdash_dashboard dash_name do
          category category_name
          dash_contents.each_pair do |key,val|
            next if key.to_sym == :graphs
            send(key, val)
          end
        end

        dash_contents[:graphs].each_pair do |component_name, options|
          gdash_dashboard_component component_name do
            dashboard_name dash_name
            dashboard_category category_name
            options.each_pair do |key,val|
              val = symbolize_keys(val) if val.is_a?(Hash)
              send(key, val)
            end
          end
        end
      end
    end
  end
end
