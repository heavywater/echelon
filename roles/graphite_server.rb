name "graphite_server"
description "construct a graphite server"

run_list [
          "recipe[graphite]",
          "recipe[iptables]",
          "recipe[graphite::firewall]",
         ]

override_attributes  'graphite' => { 'listen_port' => 9001 }

