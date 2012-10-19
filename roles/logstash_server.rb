name "logstash_server"
description "Install the logstash server and web UI"

run_list [
  "recipe[logstash::server]",
  "recipe[logstash::kibana]"
]

override_attributes :logstash => { :kibana => { :reference => "kibana-ruby" } }
