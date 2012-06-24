#
# Cookbook Name:: collectd_plugins
# Recipe:: librato
#
# Copyright 2012, Sean Escriva <sean.escriva@gmail.com>
#

case node.platform
when "ubuntu", "debian"
  package "libpython2.7"
end

cookbook_file File.join(node[:collectd][:plugin_dir], "collectd-librato.py") do
  owner "root"
  group "root"
  mode "644"
end

librato_creds = data_bag_item("librato", node.chef_environment)

collectd_python_plugin "collectd-librato" do
  options( :email => librato_creds["email"],
           "APIToken" => librato_creds["api_key"] )
end
