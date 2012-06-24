include_recipe 'iptables'

workers = search(:node, "chef_environment:#{node.chef_environment} AND (role:resque-worker OR role:app)")  || []
subnets = []

workers.each do |w|
  subnets << [ w.name, "#{w['ipaddress']}/32" ]
end

subnets.each do |h|
  template "/etc/iptables.d/#{h[0]}" do
    cookbook "cloud"
    source "whitelist.erb"
    mode "644"
    variables :subnet => h[1]
    notifies :run, "execute[rebuild-iptables]"
  end
end
