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
#centOS7 changes
 if $::operatingsystemmajrelease and $::operatingsystemmajrelease >= 7 { 

   service {'xrootd@redir.service':
     ensure    => running,
     enable    => true,
     provider  => systemd,
   }
   service {'xrootd@disk.service':
     ensure    => running,
     enable    => true,
     provider  => systemd,
  }
  service {'cmsd.service':
     ensure    => running,
     enable    => true,
     provider  => systemd,
  }

 }
  
 else {
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
}
