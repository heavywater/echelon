name "sensu"
description "base sensu role"

override_attributes :sensu => {
  :redis => {
    :host => "localhost"
  },
  :api => {
    :host => "localhost"
  },
  :dashboard => {
    :host => "localhost",
    :password => "secret"
  }
}
