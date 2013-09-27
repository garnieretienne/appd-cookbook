#
# Cookbook Name:: appd
# Recipe:: app_server
#
# Copyright (C) 2013 Etienne Garnier
# 
# All rights reserved - Do Not Redistribute
#

node['authorization']['sudo']['include_sudoers_d'] = true

include_recipe "sudo"
include_recipe "appd::_system_users"
include_recipe "nginx::repo"
include_recipe "nginx"

