#
# Cookbook:: tomcat_wrapper
# Recipe:: default
#
# Copyright:: 2018, The Authors, All Rights Reserved.
apt_update 'update' if platform_family?('debian')

include_recipe 'tomcat_wrapper::helloworld_example'
