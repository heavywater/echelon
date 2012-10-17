include_recipe "apache2"
include_recipe "git"



if Chef::Config[:solo]
  es_server_ip = node['logstash']['elasticsearch_ip']
else
  es_server_results = search(:node, "roles:#{node['logstash']['elasticsearch_role']} AND chef_environment:#{node.chef_environment}")
  unless es_server_results.empty?
    es_server_ip = es_server_results[0]['ipaddress']
  else
    es_server_ip = node['logstash']['elasticsearch_ip']
  end
end

kibana_version = node['logstash']['kibana']['reference']

apache_site "default" do
  enable false
end

directory "#{node['logstash']['basedir']}/kibana/#{kibana_version}" do
  owner node['logstash']['user']
  group node['logstash']['group']
  recursive true
end

git "#{node['logstash']['basedir']}/kibana/#{kibana_version}" do
  repository node['logstash']['kibana']['repo']
  reference kibana_version
  action :sync
  user node['logstash']['user']
  group node['logstash']['group']
end

link "#{node['logstash']['basedir']}/kibana/current" do
  to "#{node['logstash']['basedir']}/kibana/#{kibana_version}"
  notifies :restart, "service[apache2]"
end

template "#{node['apache']['dir']}/sites-available/kibana" do
  source node['logstash']['kibana']['apache_template']
  variables(:docroot => "#{node['logstash']['basedir']}/kibana/current",
            :server_name => node['logstash']['kibana']['server_name'])
end

case kibana_version
when "php-deprecated"
  include_recipe "logstash::kibana-php"
when "kibana-ruby"
  include_recipe "logstash::kibana-ruby"
else
  raise "unknown kibana branch reference"
end

apache_site "kibana"

service "apache2"
