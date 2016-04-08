class xrootd::service (
    $sysconfigfile = $xrootd::params::sysconfigfile,
    $configfile = $xrootd::params::configfile,
    $authfile = undef,
    $xrootd_instances = undef,
    $cmsd_instances = undef,
    $certificate = $xrootd::params::certificate,
    $key	= $xrootd::params::key
) inherits xrootd::params {

  Class[xrootd::config] -> Class[xrootd::service]

  if $authfile != undef {
    $files = File[$sysconfigfile, $configfile, $authfile]
  } else {
    $files = File[$sysconfigfile, $configfile]
  }

  if $certificate != undef and $key != undef  {
    if ! defined(File[$certificate]) {
	    file{$certificate:
		 ensure    => present
	    }
    }
    if ! defined(File[$key]) {
	    file{$key:
                 ensure    => present
            }
    }
    $certificates_files = File[$certificate, $key]
  }
 
 if $::operatingsystemmajrelease and $::operatingsystemmajrelease >= 7 { 

   if $xrootd_instances == undef {
	fail("xrootd_instances parameter  should  not be empty")
   }
   service {$xrootd_instances:
     ensure    => running,
     enable    => true,
     provider  => systemd,
     subscribe => $certificates_files,
   }
   if $cmsd_instances != undef {
	service {$cmsd_instances:
    	 ensure    => running,
    	 enable    => true,
	 provider  => systemd,
	 subscribe => $certificates_files,
	 require   => Service[$xrootd_instances]
   	}
   }
 }
  
 else {
  # Start the services
  service {'xrootd':
    ensure    => running,
    enable    => true,
    subscribe =>  $certificates_files ,
  }

  service {'cmsd':
    ensure    => running,
    enable    => true,
    subscribe =>  $certificates_files,
    require   => Service[$xrootd_instances],
   }
 }
}
