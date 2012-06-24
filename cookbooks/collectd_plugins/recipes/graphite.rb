#
# Cookbook Name:: collectd_plugins
# Recipe:: graphite
#
# Copyright 2012, AJ Christensen <aj@junglist.gen.nz>
#

case node.platform
when "ubuntu", "debian"
  package "nodejs"
end

script_path = File.join(node[:collectd][:plugin_dir], "collectd-graphite-proxy.js")

remote_file script_path do
  source "https://raw.github.com/loggly/collectd-to-graphite/master/collectd-graphite-proxy.js"
  owner "root"
  group "root"
  mode "644"
end

runit_service "collectd-graphite-proxy" do
  options :script_path => script_path
end

collectd_plugin "write_http" do
  options "URL" => "http://127.0.0.1:3012/post-collectd"
end
