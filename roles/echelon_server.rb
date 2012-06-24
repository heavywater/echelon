name "echelon_server"
description "meta role for Echelon monitoring and metrics server"

run_list [
          "role[openssh]",
          "role[graphite_server]",
          "role[collectd_server]",
          "role[sensu_server]",
          "role[gdash]"
         ]

override_attributes(
                    :gdash => {
                      :basic_auth => true,
                      :username => "admin",
                      :password => "secret"
                    }
                    )
