include_recipe "unicorn"

unicorn_config '/etc/unicorn/kibana.app' do
  listen '5601' => {:backlog => 100}
  working_directory node.logstash.kibana.install_dir
  worker_timeout 60
  preload_app false
  worker_processes 2
  owner 'root'
  group 'root'
end

#runit_service "kibana"
