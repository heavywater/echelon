name "graphite_server"
description "construct a graphite server"

run_list [
          "recipe[graphite]",
          "recipe[iptables]",
          "recipe[graphite::firewall]",
         ]
