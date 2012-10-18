default['logstash']['kibana']['repo'] = "git://github.com/rashidkpc/Kibana.git"
default['logstash']['kibana']['reference'] = "php-deprecated"
default['logstash']['kibana']['apache_template'] = "kibana.conf.erb"
default['logstash']['kibana']['config'] = "kibana-config.php.erb"
default['logstash']['kibana']['server_name'] = node['ipaddress']
default['apache']['default_site_enabled'] = false
kibana_version = node['logstash']['kibana']['reference']
default['logstash']['kibana']['install_dir'] = "#{node['logstash']['basedir']}/kibana/#{kibana_version}"

default['logstash']['agent']['inputs'] = []
default['logstash']['agent']['filters'] = []
default['logstash']['agent']['outputs'] = []
