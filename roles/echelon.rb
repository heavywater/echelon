name "echelon"
description "All encompassing echelon role for client and server"

run_list [
          "role[echelon_server]",
          "role[echelon_client]"
         ]
