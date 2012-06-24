name "collectd_server"
description "collectd system statistics server"

run_list [
          "recipe[collectd::server]",
          "recipe[iptables]",
          "recipe[collectd::firewall]",
          "recipe[runit]"
         ].
  concat [
          "load",
          "syslog",
          "carbon",
          "cpu",
          "df",
          "disk",
          "interface",
          "memory",
          "swap"
         ].map{ |plugin| "recipe[collectd_plugins::#{plugin}]" }
