name "logstash_client"
description "role for nodes to send log data to logstash server"

run_list [
  "recipe[logstash::agent]"
]
