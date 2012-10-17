include_recipe "apache2::mod_php5"
include_recipe "php::module_curl"


kibana_version = node['logstash']['kibana']['reference']

apache_module "php5" do
  action :enable
end

if platform? "centos", "redhat", "amazon"
  arch = node['kernel']['machine']    == "x86_64" ? "64" : ""
  file '/etc/httpd/mods-available/php5.load' do
    content "LoadModule php5_module /usr/lib#{arch}/httpd/modules/libphp5.so"
  end
end

template "#{node['logstash']['basedir']}/kibana/current/config.php" do
  source node['logstash']['kibana']['config']
  owner node['logstash']['user']
  group node['logstash']['group']
  mode "0755"
  variables(:es_server_ip => node['logstash']['elasticsearch_ip'])
end

