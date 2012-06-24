#
# Cookbook Name:: gdash
# Recipe:: default
#
# Copyright 2012, Sean Escriva <sean.escriva@gmail.com>
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
include_recipe "build-essential"
include_recipe "unicorn"

%w[libcurl4-gnutls-dev ruby1.9.1-full].each do |pkg|
  apt_package pkg
end

gem_package "bundler"

directory node.gdash.base do
  recursive true
  action :nothing
end

remote_file ::File.join(node.gdash.tarfile_dir, "gdash-#{::File.basename(node.gdash.url)}.tgz") do
  mode "00666"
  owner "www-data"
  group "www-data"
  source node.gdash.url
  action :create_if_missing
  notifies :stop, 'service[gdash]', :immediately
  notifies :delete, "directory[#{node.gdash.base}]", :immediately
end

directory node.gdash.base do
  owner "www-data"
  group "www-data"
  action :create
end

directory node.gdash.templatedir do
  owner "www-data"
  group "www-data"
  action :create
end

execute "bundle" do
  command "bundle install --binstubs #{::File.join(node.gdash.base, 'bin')} --path #{::File.join(node.gdash.base, 'vendor', 'bundle')}"
  user "www-data"
  group "www-data"
  cwd node.gdash.base
  creates ::File.join(node.gdash.base, "bin")
  action :nothing
end

ruby_block "bundle_unicorn" do
  action :nothing
  block do
    gemfile = Chef::Util::FileEdit.new(
      ::File.join(node.gdash.base, 'Gemfile')
    )
    gemfile.insert_line_if_no_match(/unicorn/, 'gem "unicorn"')
    gemfile.write_file
  end
  not_if do
    ::File.exists?(::File.join(node.gdash.base, 'Gemfile')) &&
    ::File.read(::File.join(node.gdash.base, 'Gemfile')).include?('unicorn')
  end
end

ruby_block "graphite_graph" do
  action :nothing
  block do
    gemfile_lock = Chef::Util::FileEdit.new(
      ::File.join(node.gdash.base, 'Gemfile.lock')
    )
    gemfile_lock.search_file_replace_line(/graphite_graph\s*\(0.0.1\)/, '')
    gemfile_lock.write_file
  end
  only_if do
    ::File.exists?(::File.join(node.gdash.base, 'Gemfile.lock')) &&
    ::File.read(::File.join(node.gdash.base, 'Gemfile.lock')).include?('graphite_graph (0.0.1)')
  end
end

# START
# NOTE: These blocks are only here to work around issue with graphite_graph and graphite
ruby_block "custom_graphite_graph" do
  action :nothing
  block do
    gemfile = Chef::Util::FileEdit.new(
      ::File.join(node.gdash.base, 'Gemfile')
    )
    gemfile.search_file_replace_line(
      /graphite_graph/,
      "gem 'graphite_graph', :git => '#{node[:gdash][:graphite_graph_repository]}', :branch => '#{node[:gdash][:graphite_graph_branch]}'"
    )
    gemfile.write_file
  end
  not_if do
    node[:gdash][:graphite_graph_repository].nil? || (
      ::File.exists?(::File.join(node.gdash.base, 'Gemfile')) &&
      ::File.read(
        ::File.join(node.gdash.base, 'Gemfile')
      ).include?(
        "gem 'graphite_graph', :git => '#{node[:gdash][:graphite_graph_repository]}', :branch => '#{node[:gdash][:graphite_graph_branch]}'"
      )
    )
  end
end

package 'git' do
  not_if{ node[:gdash][:graphite_graph_repository].nil? }
end
# END

directory ::File.join(node.gdash.templatedir) do
  action :nothing
  recursive true
end

execute "gdash: untar" do
  command "tar zxf #{::File.join(node.gdash.tarfile_dir, "gdash-#{::File.basename(node.gdash.url)}.tgz")} -C #{node.gdash.base} --strip-components=1"
  creates ::File.join(node.gdash.base, "Gemfile.lock")
  user "www-data"
  group "www-data"
  notifies :create, resources(:ruby_block => "bundle_unicorn"), :immediately
  notifies :create, resources(:ruby_block => "graphite_graph"), :immediately
  notifies :create, resources(:ruby_block => "custom_graphite_graph"), :immediately
  notifies :delete, resources(:directory => ::File.join(node.gdash.templatedir)), :immediately
  notifies :run, resources(:execute => "bundle"), :immediately
end

template ::File.join(node.gdash.base, "config", "gdash.yaml") do
  owner "www-data"
  group "www-data"
  notifies :restart, "service[gdash]"
end

unicorn_config '/etc/unicorn/gdash.app' do
  listen '9292' => {:backlog => 100}
  working_directory node.gdash.base
  worker_timeout 60
  preload_app false
  worker_processes 2
  owner 'root'
  group 'root'
end

runit_service "gdash"

