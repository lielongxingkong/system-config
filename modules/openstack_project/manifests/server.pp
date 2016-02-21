# == Class: openstack_project::server
#
# A server that we expect to run for some time
class openstack_project::server (
  $sysadmins                 = [],
  $certname                  = $::fqdn,
  $pin_puppet                = '3.',
  $ca_server                 = undef,
  $enable_unbound            = false,
  $afs                       = false,
  $afs_cache_size            = 500000,
  $puppetmaster_server       = 'puppetmaster.openstack.org',
  $manage_exim               = true,
  $pypi_index_url            = 'https://pypi.python.org/simple',
) {
  class { 'openstack_project::template':
    certname                  => $certname,
    pin_puppet                => $pin_puppet,
    ca_server                 => $ca_server,
    puppetmaster_server       => $puppetmaster_server,
    enable_unbound            => $enable_unbound,
    afs                       => $afs,
    afs_cache_size            => $afs_cache_size,
    manage_exim               => $manage_exim,
    sysadmins                 => $sysadmins,
    pypi_index_url            => $pypi_index_url,
    purge_apt_sources         => true,
  }
}
