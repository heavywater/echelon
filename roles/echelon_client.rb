name "echelon_client"
description "meta role for echelon monitoring clients"

run_list [
          "role[sensu_client]",
          "role[collectd_client]"
         ]
