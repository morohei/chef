#
# Cookbook Name:: newrelic
# Recipe:: default
#
# Copyright 2017, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

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

 # yum
 yum_package "newrelic-php5" do
    action :install
 end

 # newrelic install
 bash 'newrelic-install' do
    command 'newrelic-install install'
 end

 # newrelic.ini
 template 'node[newrelic][conf-path]' do
    source 'newrelic.ini.erb'
    owner 'root'
    group 'root'
    mode '0644'
 end

end
