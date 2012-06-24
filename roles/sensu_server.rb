name "sensu_server"
description "sensu monitoring server"

run_list [
          "recipe[sensu::redis]",
          "recipe[sensu::rabbitmq]",
          "recipe[sensu::server]",
          "recipe[sensu::api]",
          "recipe[sensu::dashboard]",
          "recipe[iptables]",
          "recipe[sensu::firewall]",
          "role[sensu_client]"
         ]

override_attributes :redis => {
  :listen_addr => "0.0.0.0"
}
