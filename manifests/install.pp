class xrootd::install (
) inherits xrootd::params {

  Class[xrootd::install] -> Class[xrootd::config]

    package {"xrootd":
      ensure => present
    }
}
