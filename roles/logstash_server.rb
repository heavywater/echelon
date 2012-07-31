name "logstash_server"
description "the logstash server-side components (for a single machine)"
run_list [
          "recipe[logstash::server]",
          "recipe[logstash::kibana]",
          "recipe[logstash::firewall]"
         ]

override_attributes :logstash => {
  :server => {
    :inputs => [
      :tcp => {
        :type => "tcp-input",
        :port => "5959",
        :format => "json_event"
      },
      :file => {
        :type => "sample-logs",
        :path => "/var/log/*.log",
        :exclude => "*.gz",
        :debug => true
      }
    ]
  }
}
