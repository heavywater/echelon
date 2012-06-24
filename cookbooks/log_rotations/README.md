LogRotations
============

This cookbook provides an extremely simple way to create log rotations via
attributes. It depends on the logrotate cookbook. Simple example:

```ruby
override_attributes(
  :log_rotations => [
    {:name => 'chef-client', :path => '/var/log/chef/client.log'},
    {:name => 'nginx', :path => '/var/log/nginx/access.log', :frequency => 'daily'}
  ]
)
```

Useful keys within the hash:

* name - required
* path - required
* frequency - defaults to 'weekly'
* rotate - defaults to 30
* create - defaults to '644 root root'

Cookbook Info
=============

Repo: https://github.com/chrisroberts/cookbook-log_rotations
