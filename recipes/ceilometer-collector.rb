#
# Cookbook Name:: nova
# Recipe:: ceilometer-collector
#
# Copyright 2012, AT&T
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

class ::Chef::Recipe
  include ::Openstack
end

include_recipe "nova::ceilometer-common"

bindir = '/usr/local/bin'
conf_switch = '--config-file /etc/ceilometer/ceilometer.conf'

service "ceilometer-collector" do
  service_name "ceilometer-collector"
  action [:enable, :start]
  start_command "nohup #{bindir}/ceilometer-collector #{conf_switch} &"
  stop_command "pkill -f ceilometer-collector"
end