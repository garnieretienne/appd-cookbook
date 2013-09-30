#
# Cookbook Name:: appd
# Recipe:: app_server
#
# Copyright (C) 2013 Etienne Garnier
# 
# All rights reserved - Do Not Redistribute
#

node.default['authorization']['sudo']['include_sudoers_d'] = true

include_recipe "sudo"
include_recipe "appd::_system_users"
include_recipe "nginx::repo"
include_recipe "nginx"
include_recipe "git"
include_recipe "appd::_git_service"
include_recipe "appd::_devops"

