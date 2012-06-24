name "gdash"
description "gdash graphite dashboard"

run_list [
          "recipe[gdash]",
          "recipe[iptables]",
          "recipe[gdash::firewall]",
          "recipe[gdash::basic_dashboard]",
          "recipe[gdash::graph_generator]"
         ]

