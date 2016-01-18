class xrootd::service (
    $sysconfigfile = $xrootd::params::sysconfigfile,
    $configfile = $xrootd::params::configfile,
    $authfile = undef
) inherits xrootd::params {

  Class[xrootd::config] -> Class[xrootd::service]

  if $authfile != undef {
    $files = File[$sysconfigfile, $configfile, $authfile]
  } else {
    $files = File[$sysconfigfile, $configfile]
  }

  # Start the services
  service {'xrootd':
    ensure    => running,
    enable    => true,
    #subscribe => [$files],
  }

  service {'cmsd':
    ensure    => running,
    enable    => true,
    #subscribe => [$files],
   }
}
