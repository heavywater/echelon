name "collectd_client"
description "collectd metrics client role"

run_list [
          "recipe[collectd::client]"
         ].
  concat [
          "load",
          "syslog",
          "cpu",
          "df",
          "disk",
          "interface",
          "memory",
          "swap"
         ].map{ |plugin| "recipe[collectd_plugins::#{plugin}]" }
