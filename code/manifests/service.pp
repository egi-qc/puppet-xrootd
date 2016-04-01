class xrootd::service (
    $sysconfigfile = $xrootd::params::sysconfigfile,
    $configfile = $xrootd::params::configfile,
    $authfile = undef,
    $xrootd_instances = undef,
    $cmsd_instances = undef,
    $certificates = $xrootd::params::certificates,
) inherits xrootd::params {

  Class[xrootd::config] -> Class[xrootd::service]

  if $authfile != undef {
    $files = File[$sysconfigfile, $configfile, $authfile]
  } else {
    $files = File[$sysconfigfile, $configfile]
  }
 
 if $::operatingsystemmajrelease and $::operatingsystemmajrelease >= 7 { 

   if $xrootd_instances == undef {
	fail("xrootd_instances parameter  should  not be empty")
   }
   service {$xrootd_instances:
     ensure    => running,
     enable    => true,
     provider  => systemd,
     subscribe => File[$certificates],
   }
   if $cmsd_instances != undef {
	service {$cmsd_instances:
    	 ensure    => running,
    	 enable    => true,
	 provider  => systemd,
	 subscribe => File[$certificates],
   	}
   }
 }
  
 else {
  # Start the services
  service {'xrootd':
    ensure    => running,
    enable    => true,
    subscribe => File[$certificates],
  }

  service {'cmsd':
    ensure    => running,
    enable    => true,
    subscribe => File[$certificates],
   }
 }
}
