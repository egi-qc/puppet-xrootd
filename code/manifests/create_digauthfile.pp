define xrootd::create_digauthfile (
  $filename = $title,
  $template = $xrootd::config::digauthfile_template,
  $host,
  $group,
) {
  include xrootd::config

  file {$filename:
    ensure  => file,
    owner   => $::xrootd_user,
    group   => $::xrootd_group,
    content => template($template)
  }

}
