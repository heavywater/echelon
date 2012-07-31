name "logstash_client"
description "client-side logstash components (agent)"
run_list [
          "recipe[logstash::agent]"
         ]

