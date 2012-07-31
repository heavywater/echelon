name "logstash_server"
description "the logstash server-side components (for a single machine)"
run_list [
          "recipe[logstash::server]",
          "recipe[logstash::kibana]"
         ]
