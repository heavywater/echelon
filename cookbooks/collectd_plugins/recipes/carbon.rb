#
# Cookbook Name:: collectd_plugins
# Recipe:: graphite
#
# Copyright 2012, AJ Christensen <aj@junglist.gen.nz>
#

case node.platform
when "ubuntu", "debian"
  package "libpython2.7"
end

remote_file File.join(node[:collectd][:plugin_dir], "carbon_writer.py") do
  source "https://raw.github.com/indygreg/collectd-carbon/master/carbon_writer.py"
  owner "root"
  group "root"
  mode "644"
  action :create_if_missing
end

collectd_python_plugin "carbon_writer" do
  options(:line_receiver_host => "127.0.0.1",
          :line_receiver_port => 2003,
          :differentiate_counters_over_time => true,
          :lowercase_metric_names => true,
          "TypesDB" => node[:collectd][:types_db],
          :metric_prefix => "collectd" )
end
