#
# Long lived servers:
#
# Node-OS: precise
# Node-OS: trusty
node 'review.incloud-ci.com' {
  class { 'openstack_project::server':
    sysadmins                 => hiera('sysadmins', []),
    puppetmaster_server       => 'puppetmaster.incloud-ci.com',
  }

  class { '::gerrit::mysql':
    mysql_root_password => 'root',
    database_name       => 'reviewdb',
    database_user       => 'gerrit2',
    database_password   => 'root',
  }

  class { 'openstack_project::review':
    project_config_repo         => hiera('project_config_repo'),
    ssl_cert_file           => '/etc/ssl/certs/ssl-cert-snakeoil.pem',
    ssl_key_file            => '/etc/ssl/private/ssl-cert-snakeoil.key',
    ssl_chain_file          => '',

    ssh_rsa_key_contents                => hiera('gerrit_ssh_rsa_key_contents'),
    ssh_rsa_pubkey_contents             => hiera('gerrit_ssh_rsa_pubkey_contents'),
    ssh_project_rsa_key_contents        => hiera('pm_ssh_rsa_key_contents'),
    ssh_project_rsa_pubkey_contents     => hiera('pm_ssh_rsa_pubkey_contents'),
    ssh_replication_rsa_key_contents    => hiera('gerrit_ssh_rsa_key_contents'),
    ssh_replication_rsa_pubkey_contents => hiera('gerrit_ssh_rsa_pubkey_contents'),
    ssh_zuul_rsa_pubkey_contents        => hiera('zuul_ssh_rsa_pubkey_contents'),

    gitlab_root_passwd      => hiera('gitlab_root_passwd'),
    gitlab_gerrit_passwd    => hiera('gitlab_gerrit_passwd'),

    mysql_host              => 'localhost',
    mysql_password          => 'root',
    contactstore            => false,
  }
}

#
# A sample puppet node configuration that installs and configures Jenkins,
# Zuul, Nodepool, Jenkins Job Builder, onto a single VM using the
# specified project-config repository and other configurations stored in hiera.
# Zuul status page will be available on port 80
# Jenkins UI will be available on port 8080
# Default values are provided where reasonable options are available assuming
# use of the review.openstack.org Gerrit server and for an unsecured Jenkins.
# All others must be provided by hiera. See the related single_node_ci_hiera.yaml
# which includes all optional and required parameters.

node 'singlenode.incloud-ci.com' {
  # If the fqdn is not resolvable, use its ip address
  class { 'openstack_project::server':
    sysadmins                 => hiera('sysadmins', []),
    puppetmaster_server       => 'puppetmaster.incloud-ci.com',
  }

  class { '::openstackci::single_node_ci':
    vhost_name                  => hiera('singlenode_vhost_name'),
    project_config_repo         => hiera('project_config_repo'),
    serveradmin                 => hiera('serveradmin', "webmaster@incloud-ci.com"),
    jenkins_username            => hiera('jenkins_username', 'jenkins'),
    jenkins_password            => hiera('jenkins_password', 'XXX'),
    jenkins_ssh_private_key     => hiera('zuul_ssh_rsa_key_contents'),
    jenkins_ssh_public_key      => hiera('zuul_ssh_rsa_pubkey_contents'),
    gerrit_server               => hiera('gerrit_server', 'review.incloud-ci.com'),
    gerrit_user                 => hiera('gerrit_user'),
    gerrit_user_ssh_public_key  => hiera('zuul_ssh_rsa_pubkey_contents'),
    gerrit_user_ssh_private_key => hiera('zuul_ssh_rsa_key_contents'),
    gerrit_ssh_host_key         => hiera('gerrit_ssh_host_key',
      'review.incloud-ci.com,23.253.232.87,2001:4800:7815:104:3bc3:d7f6:ff03:bf5d b8:3c:72:82:d5:9e:59:43:54:11:ef:93:40:1f:6d:a5'),
    git_email                   => hiera('git_email'),
    git_name                    => hiera('git_name'),
    log_server                  => hiera('log_server'),
    smtp_host                   => hiera('smtp_host', 'localhost'),
    smtp_default_from           => hiera('smtp_default_from', "zuul@incloud-ci.com"),
    smtp_default_to             => hiera('smtp_default_to', "zuul.reports@incloud-ci.com"),
    zuul_revision               => hiera('zuul_revision', 'master'),
    zuul_git_source_repo        => hiera('zuul_git_source_repo',
      'https://git.openstack.org/openstack-infra/zuul'),
    oscc_file_contents          => hiera('oscc_file_contents', ''),
    mysql_root_password         => hiera('mysql_root_password'),
    mysql_nodepool_password     => hiera('mysql_nodepool_password'),
    nodepool_jenkins_target     => hiera('nodepool_jenkins_target', 'jenkins1'),
    jenkins_api_key             => hiera('jenkins_api_key', 'XXX'),
    jenkins_credentials_id      => hiera('jenkins_credentials_id', 'XXX'),
    nodepool_revision           => hiera('nodepool_revision', 'master'),
    nodepool_git_source_repo    => hiera('nodepool_git_source_repo',
      'https://git.openstack.org/openstack-infra/nodepool'),
  }
}

#
# A sample puppet node configuration that installs and configures a server
# that hosts log files that are viewable in a browser.
# Note that using swift is optional and the defaults provided disable its
# usage.

node 'logserver.incloud-ci.com' {
  # If the fqdn is not resolvable, use its ip address
  class { 'openstack_project::server':
    sysadmins                 => hiera('sysadmins', []),
    puppetmaster_server       => 'puppetmaster.incloud-ci.com',
  }

  class { '::openstackci::logserver':
    domain                  => hiera('domain'),
    jenkins_ssh_key         => hiera('jenkins_ssh_rsa_pubkey_contents'),
    swift_authurl           => hiera('swift_authurl', ''),
    swift_user              => hiera('swift_user', ''),
    swift_key               => hiera('swift_key', ''),
    swift_tenant_name       => hiera('swift_tenant_name', ''),
    swift_region_name       => hiera('swift_region_name', ''),
    swift_default_container => hiera('swift_default_container', ''),
  }
}
