########################################################################
# Toggles - These can be overridden at the environment level
default["enable_monit"] = false  # OS provides packages
########################################################################

# Set to some text value if you want templated config files
# to contain a custom banner at the top of the written file
default["nova"]["custom_template_banner"] = "
# This file autogenerated by Chef
# Do not edit, changes will be overwritten
"

# The name of the Chef role that knows about the message queue server
# that Nova uses
default["nova"]["rabbit_server_chef_role"] = "rabbitmq-server"

# The name of the Chef role that sets up the Keystone Service API
default["nova"]["keystone_service_chef_role"] = "keystone"

# This user's password is stored in an encrypted databag
# and accessed with openstack-common cookbook library's
# db_password routine.
default["nova"]["db"]["username"] = "nova"

# This user's password is stored in an encrypted databag
# and accessed with openstack-common cookbook library's
# user_password routine.  You are expected to create
# the user, pass, vhost in a wrapper rabbitmq cookbook.
default["nova"]["rabbit"]["username"] = "rabbit"
default["nova"]["rabbit"]["vhost"] = "/nova"

default["nova"]["service_tenant_name"] = "service"
default["nova"]["service_user"] = "nova"
default["nova"]["service_role"] = "admin"

# Controls for the PKI options in the auth_token middleware
# that is in the paste INI files.
default["nova"]["pki"]["signing_dir"] = "/tmp/nova-signing-dir"

case platform
when "fedora", "redhat", "centos", "ubuntu"
  default["nova"]["user"] = "nova"
  default["nova"]["group"] = "nova"
when "suse"
  default["nova"]["user"] = "openstack-nova"
  default["nova"]["group"] = "openstack-nova"
end

# Logging stuff
default["nova"]["syslog"]["use"] = false
default["nova"]["syslog"]["facility"] = "LOG_LOCAL1"
default["nova"]["syslog"]["config_facility"] = "local1"

default["nova"]["region"] = "RegionOne"

default["nova"]["floating_cmd"] = "/usr/local/bin/add_floaters.py"

# TODO(shep): This should probably be ['nova']['network']['fixed']
default["nova"]["networks"] = [
        {
                "label" => "public",
                "ipv4_cidr" => "192.168.100.0/24",
                "num_networks" => "1",
                "network_size" => "255",
                "bridge" => "br100",
                "bridge_dev" => "eth2",
                "dns1" => "8.8.8.8",
                "dns2" => "8.8.4.4",
                "multi_host" => 'T'
        },
        {
                "label" => "private",
                "ipv4_cidr" => "192.168.200.0/24",
                "num_networks" => "1",
                "network_size" => "255",
                "bridge" => "br200",
                "bridge_dev" => "eth3",
                "dns1" => "8.8.8.8",
                "dns2" => "8.8.4.4",
                "multi_host" => 'T'
        }
]

# For VLAN Networking, do the following:
#
# default["nova"]["network"]["network_manager"] = "nova.network.manager.VlanManager"
# default["nova"]["network"]["vlan_interface"] = "eth1"  # Or "eth2", "bond1", etc...
# # The fixed_range setting is the **entire** subnet/network that all your VLAN
# # networks will fit inside.
# default["nova"]["network"]["fixed_range"] = "10.0.0.0/8"  # Or smaller for smaller deploys...
#
# In addition to the above, you typically either want to do one of the following:
#
# 1) Set default["nova"]["networks"] to an empty Array ([]) and create your
#    VLAN networks (using nova-manage network create) **when you create a tenant**.
#
# 2) Set default["nova"]["networks"] to an Array of VLAN networks that get created
#    **without a tenant assignment** for tenants to use when they are created later.
#    Such an array might look like this:
#
#    default["nova"]["networks"] = [
#       {
#         "label": "vlan100",
#         "vlan": "100",
#         "ipv4_cidr": "10.0.100.0/24"
#       },
#       {
#         "label": "vlan101",
#         "vlan": "101",
#         "ipv4_cidr": "10.0.101.0/24"
#       },
#       {
#         "label": "vlan102",
#         "vlan": "102",
#         "ipv4_cidr": "10.0.102.0/24"
#       },
#    ]

default["nova"]["network"]["multi_host"] = false
default["nova"]["network"]["fixed_range"] = default["nova"]["networks"][0]["ipv4_cidr"]
# DMZ CIDR is a range of IP addresses that should not
# have their addresses SNAT'ed by the nova network controller
default["nova"]["network"]["dmz_cidr"] = "10.128.0.0/24"
default["nova"]["network"]["network_manager"] = "nova.network.manager.FlatDHCPManager"
default["nova"]["network"]["public_interface"] = "eth0"
default["nova"]["network"]["vlan_interface"] = "eth0"
# https://bugs.launchpad.net/nova/+bug/1075859
default["nova"]["network"]["use_single_default_gateway"] = false

default["nova"]["scheduler"]["scheduler_driver"] = "nova.scheduler.filter_scheduler.FilterScheduler"
default["nova"]["scheduler"]["default_filters"] = ["AvailabilityZoneFilter",
                                                   "RamFilter",
                                                   "ComputeFilter",
                                                   "CoreFilter",
                                                   "SameHostFilter",
                                                   "DifferentHostFilter"]
default["nova"]["libvirt"]["virt_type"] = "kvm"
default["nova"]["libvirt"]["vncserver_listen"] = node["ipaddress"]
default["nova"]["libvirt"]["vncserver_proxyclient_address"] = node["ipaddress"]
default["nova"]["libvirt"]["auth_tcp"] = "none"
default["nova"]["libvirt"]["remove_unused_base_images"] = true
default["nova"]["libvirt"]["remove_unused_resized_minimum_age_seconds"] = 3600
default["nova"]["libvirt"]["remove_unused_original_minimum_age_seconds"] = 3600
default["nova"]["libvirt"]["checksum_base_images"] = false
default["nova"]["config"]["availability_zone"] = "nova"
default["nova"]["config"]["storage_availability_zone"] = "nova"
default["nova"]["config"]["default_schedule_zone"] = "nova"
default["nova"]["config"]["force_raw_images"] = false
default["nova"]["config"]["allow_same_net_traffic"] = true
default["nova"]["config"]["osapi_max_limit"] = 1000
default["nova"]["config"]["cpu_allocation_ratio"] = 16.0
default["nova"]["config"]["ram_allocation_ratio"] = 1.5
default["nova"]["config"]["snapshot_image_format"] = "qcow2"
# `start` will cause nova-compute to error out if a VM is already running, where
# `resume` checks to see if it is running first.
default["nova"]["config"]["start_guests_on_host_boot"] = false
# requires https://review.openstack.org/#/c/8423/
default["nova"]["config"]["resume_guests_state_on_host_boot"] = true

# Volume API class (driver)
default["nova"]["config"]["volume_api_class"] = "nova.volume.cinder.API"

# quota settings
default["nova"]["config"]["quota_security_groups"] = 50
default["nova"]["config"]["quota_security_group_rules"] = 20

default["nova"]["ratelimit"]["settings"] = {
    "generic-post-limit" => { "verb" => "POST", "uri" => "*", "regex" => ".*", "limit" => "10", "interval" => "MINUTE" },
    "create-servers-limit" => { "verb" => "POST", "uri" => "*/servers", "regex" => "^/servers", "limit" => "50", "interval" => "DAY" },
    "generic-put-limit" => { "verb" => "PUT", "uri" => "*", "regex" => ".*", "limit" => "10", "interval" => "MINUTE" },
    "changes-since-limit" => { "verb" => "GET", "uri" => "*changes-since*", "regex" => ".*changes-since.*", "limit" => "3", "interval" => "MINUTE" },
    "generic-delete-limit" => { "verb" => "DELETE", "uri" => "*", "regex" => ".*", "limit" => "100", "interval" => "MINUTE" }
}
default["nova"]["ratelimit"]["api"]["enabled"] = true

# Keystone PKI signing directory. Only written to the filter:authtoken section
# of the api-paste.ini when node["openstack"]["auth"]["strategy"] == "pki"
default["nova"]["api"]["auth"]["cache_dir"] = "/var/cache/nova/api"
default["nova"]["ceilometer-api"]["auth"]["cache_dir"] = "/var/cache/nova/ceilometer-api"

case platform
when "fedora", "redhat", "centos", "suse" # :pragma-foodcritic: ~FC024 - won't fix this
  default["nova"]["platform"] = {
    "api_ec2_packages" => ["openstack-nova-api"],
    "api_ec2_service" => "openstack-nova-api",
    "api_os_compute_packages" => ["openstack-nova-api"],
    "api_os_compute_service" => "openstack-nova-api",
    "api_os_compute_process_name" => "nova-api",
    "nova_api_metadata_packages" => ["openstack-nova-api"],
    "nova_api_metadata_process_name" => "nova-api",
    "nova_api_metadata_service" => "openstack-nova-api",
    "nova_compute_packages" => ["openstack-nova-compute"],
    "nova_compute_service" => "openstack-nova-compute",
    "nova_network_packages" => ["iptables", "openstack-nova-network"],
    "nova_network_service" => "openstack-nova-network",
    "nova_scheduler_packages" => ["openstack-nova-scheduler"],
    "nova_scheduler_service" => "openstack-nova-scheduler",
    "nova_vncproxy_packages" => ["openstack-nova-novncproxy"], # me thinks this is right?
    "nova_vncproxy_service" => "openstack-nova-novncproxy",
    "nova_vncproxy_consoleauth_packages" => ["openstack-nova-console"],
    "nova_vncproxy_consoleauth_service" => "openstack-nova-console",
    "nova_vncproxy_consoleauth_process_name" => "nova-console",
    "libvirt_packages" => ["libvirt"],
    "libvirt_service" => "libvirtd",
    "nova_cert_packages" => ["openstack-nova-cert"],
    "nova_cert_service" => "openstack-nova-cert",
    "mysql_service" => "mysqld",
    "common_packages" => ["openstack-nova-common"],
    "iscsi_helper" => "ietadm",
    "package_overrides" => ""
  }
  if platform == "suse"
    default["nova"]["platform"]["common_packages"] = ["openstack-nova"]
  end

when "ubuntu"
  default["nova"]["platform"] = {
    "api_ec2_packages" => ["nova-api-ec2"],
    "api_ec2_service" => "nova-api-ec2",
    "api_os_compute_packages" => ["nova-api-os-compute"],
    "api_os_compute_process_name" => "nova-api-os-compute",
    "api_os_compute_service" => "nova-api-os-compute",
    "nova_api_metadata_packages" => ["nova-api-metadata"],
    "nova_api_metadata_service" => "nova-api-metadata",
    "nova_api_metadata_process_name" => "nova-api-metadata",
    "nova_compute_packages" => ["nova-compute"],
    "nova_compute_service" => "nova-compute",
    "nova_network_packages" => ["iptables", "nova-network"],
    "nova_network_service" => "nova-network",
    "nova_scheduler_packages" => ["nova-scheduler"],
    "nova_scheduler_service" => "nova-scheduler",
    # Websockify is needed due to https://bugs.launchpad.net/ubuntu/+source/nova/+bug/1076442
    "nova_vncproxy_packages" => ["novnc", "websockify", "nova-novncproxy"],
    "nova_vncproxy_service" => "nova-novncproxy",
    "nova_vncproxy_consoleauth_packages" => ["nova-consoleauth"],
    "nova_vncproxy_consoleauth_service" => "nova-consoleauth",
    "nova_vncproxy_consoleauth_process_name" => "nova-consoleauth",
    "libvirt_packages" => ["libvirt-bin"],
    "libvirt_service" => "libvirt-bin",
    "nova_cert_packages" => ["nova-cert"],
    "nova_cert_service" => "nova-cert",
    "mysql_service" => "mysql",
    "common_packages" => ["nova-common"],
    "iscsi_helper" => "tgtadm",
    "package_overrides" => "-o Dpkg::Options::='--force-confold' -o Dpkg::Options::='--force-confdef'"
  }
end

# ceilometer specific attrs
default["nova"]["ceilometer"]["api_logdir"] = "/var/log/ceilometer-api"
default["nova"]["ceilometer"]["branch"] = 'stable/folsom'
default["nova"]["ceilometer"]["conf"] = "/etc/ceilometer/ceilometer.conf"
default["nova"]["ceilometer"]["db"]["username"] = 'ceilometer'
default["nova"]["ceilometer"]["dependent_pkgs"] = ['libxslt-dev', 'libxml2-dev']
default["nova"]["ceilometer"]["install_dir"] = '/opt/ceilometer'
