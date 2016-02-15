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
    project_config_repo     => 'https://git.openstack.org/openstack-infra/project-config',
    ssl_cert_file           => '/etc/ssl/certs/ssl-cert-snakeoil.pem',
    ssl_key_file            => '/etc/ssl/private/ssl-cert-snakeoil.key',
    ssl_chain_file          => '',
    mysql_host              => 'localhost',
    mysql_password          => 'root',
    contactstore            => false,
  }
}
