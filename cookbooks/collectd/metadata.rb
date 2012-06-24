maintainer       "Noan Kantrowitz"
maintainer_email "nkantrowitz@crypticstudios.com"
license          "Apache 2.0"
description      "Install and configure the collectd monitoring daemon"
long_description IO.read(File.join(File.dirname(__FILE__), 'README.rdoc'))
version          "1.0.1"
supports         "ubuntu"

depends "discovery"
depends "perl"
suggests "iptables"
