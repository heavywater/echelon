#
# Cookbook Name:: collectd_plugins
# Recipe:: chef
#
# Copyright 2010, Atari
#
# All rights reserved - Do Not Redistribute
#

include_recipe "collectd"

class ChefCollectdPluginReportHandler < Chef::Handler
  def report
    Chef::Log.info('Running collectd hander')
    node[:last_success_time] = Time.now.to_f
    node[:error_count_since_success] = 0
    node.save
  end
end

class ChefCollectdPluginErrorHandler < Chef::Handler
  def report
    node[:last_error_time] = Time.now.to_f
    if not node.include? :error_count
      node[:error_count] = 0
    end
    node[:error_count] += 1
    if not node.include? :error_count_since_success
      node[:error_count_since_success] = 0
    end
    node[:error_count_since_success] += 1
    node.save
  end
end

# Remove any previous instances so we don't end up with more than one
# This cannot use is_a? since the class gets recompiled on each run
Chef::Config.report_handlers.delete_if {|v| v.class.to_s.include? 'ChefCollectdPluginReportHandler'}
Chef::Config.report_handlers << ChefCollectdPluginReportHandler.new

Chef::Config.exception_handlers.delete_if {|v| v.class.to_s.include? 'ChefCollectdPluginErrorHandler'}
Chef::Config.exception_handlers << ChefCollectdPluginErrorHandler.new

cookbook_file File.join(node[:collectd][:plugin_dir], "chef.py") do
  owner "root"
  group "root"
  mode "644"
end

collectd_python_plugin "chef" do
  options :verbose=>true
end
