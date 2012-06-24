name "openssh"
description "setup openssh and firewall"

run_list [
          "recipe[openssh]",
          "recipe[openssh::firewall]"
         ]
