class xrootd::config (

  $xrootd_user = $xrootd::params::xrootd_user,
  $xrootd_group = $xrootd::params::xrootd_group,

  $configdir = $xrootd::params::configdir,
  $logdir = $xrootd::params::logdir,
  $spooldir = $xrootd::params::spooldir,
  $all_pidpath = $xrootd::params::all_pidpath,

) inherits xrootd::params {

  include fetchcrl

  exec {"run-fetchcrl-atleastonce":
    path    => "/bin:/usr/bin:/sbin:/usr/sbin",
    command => "fetch-crl",
    unless  => "ls /etc/grid-security/certificates/*.r0"
  }
 
  exec {
    'systemctl-daemon-reload-xrootd':
      command => '/usr/bin/systemctl daemon-reload',
      refreshonly => true,
  }

  if $::architecture == "x86_64" {
    $xrdlibdir = "lib64"
  } else {
    $xrdlibdir = "lib"
  }

  file {$configdir:
    ensure	=> directory,
    owner  => $xrootd_user,
    group  => $xrootd_group
  }

  file {$logdir:
    ensure => directory,
    owner  => $xrootd_user,
    group  => $xrootd_group
  }

  file {$spooldir:
   ensure => directory,
   owner  => $xrootd_user,
   group  => $xrootd_group
  }

  file {$all_pidpath:
   ensure => directory,
   owner  => $xrootd_user,
   group  => $xrootd_group
  }
}
