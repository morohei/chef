#
# Cookbook Name:: newrelic
# Recipe:: default
#
# Copyright 2017, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

php_path ="#{node['newrelic']['php_path']}"

if node["hostname"] == node["newrelic"]["hostname"]

 # rpm
 remote_file "#{Chef::Config[:file_cache_path]}/newrelic-repo-5-3.noarch.rpm" do
    source "http://yum.newrelic.com/pub/newrelic/el5/x86_64/newrelic-repo-5-3.noarch.rpm"
    not_if "rpm -qa | grep -q '^newrelic-repo'"
    action :create
    notifies :install, "rpm_package[newrelic-agent]", :immediately
 end

 rpm_package "newrelic-agent" do
    source "#{Chef::Config[:file_cache_path]}/newrelic-repo-5-3.noarch.rpm"
    action :nothing
 end

 yum_package "newrelic-php5" do
    action :install
 end

  template "/etc/newrelic/newrelic.cfg" do
    source "newrelic.cfg.erb"
    mode  644
    owner "root"
    group "root"
    action :create
  end

  execute "newrelic-php-install" do
    command <<-EOH
     newrelic-install install
    EOH
  end

  template "#{php_path}" do
    source "newrelic.ini.erb"
    mode  644
    owner "root"
    group "root"
    action :create
  end


  #service "php70-php-fpm" do
  #   action [:restart]
  #end

  #service "nginx" do
  #   action [:restart]
  #end

end
