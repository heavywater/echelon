# use collectd filecount plugin to track queue length
collectd_plugin "filecount" do
  template "qmail_filecount.conf.erb"
  cookbook "collectd_plugins"
end
