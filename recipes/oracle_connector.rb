# encoding: UTF-8
# rubocop:disable LineLength
#
# Cookbook Name:: wildfly
# Recipe:: Oracle_connector
#
# Copyright (C) 2014 Brian Dwyer - Intelligent Digital Services
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#    http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

# => Make Oracle Connector/J Information Retrievable
node.default['wildfly']['oracle']['version'] = ::File.basename(node['wildfly']['oracle']['url'], '.jar')
node.default['wildfly']['oracle']['jar'] = "#{node['wildfly']['oracle']['version']}.jar"

# => Shorten Hashes
wildfly = node['wildfly']
oracle = node['wildfly']['oracle']

# => Shorten Connector/J Directory Name
oracle_dir = ::File.join(wildfly['base'], 'modules', 'system', 'layers', 'base', 'com', 'oracle', 'main')

# => Create oracle Directory
directory oracle_dir do
  owner wildfly['user']
  group wildfly['group']
  mode '0755'
  recursive true
end

# => Download Oracle driver
remote_file "#{oracle_dir}/#{oracle['jar']}" do
  source oracle['url']
  action :create
end

# => Configure Oracle Module
template ::File.join(oracle_dir, 'module.xml') do
  source 'module.xml.erb'
  user wildfly['user']
  group wildfly['group']
  mode '0644'
  variables(
    module_name: oracle['mod_name'],
    resource_path: oracle['jar'],
    module_dependencies: oracle['mod_deps']
  )
  action :create
#  notifies :restart, "service[#{wildfly['service']}]", :delayed
end
