name "sensu_client"
description "sensu monitoring client"

run_list [
          "recipe[log_rotations]",
          "recipe[sensu::client]",
          "role[sensu]"
         ]

override_attributes(
         :log_rotations => [
             {:name => 'sensu-client', :path => '/var/log/sensu/sensu-client.log'}
         ]
)
