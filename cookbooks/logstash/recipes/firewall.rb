#
# Cookbook Name:: logstash
# Recipe:: firewall
#

ports = []

node['logstash']['server']['inputs'].each do |inputs|
  ports = inputs.inject([]) do |ports, (input,params)|
    ports << params['port'] if input.to_s =~ /tcp/
    ports
  end
end

iptables_rule "port_logstash" do
  variables :logstash_server_inputs => ports
end
