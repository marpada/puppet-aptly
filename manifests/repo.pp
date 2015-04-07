# == Define: aptly::repo
#
# Create a repository using `aptly create`. It will not snapshot, or update the
# repository for you, because it will take a long time and it doesn't make sense
# to schedule these actions frequently in Puppet.
#
# === Parameters
#
# [*component*]
#   Specify which component to put the package in. This option will only works
#   for aptly version >= 0.5.0.
# [*distribution*]
#   Specify a distribution name, e.g. squeeze,
#   for flat repositories use ./ instead of distribution name
#
define aptly::repo(
  $component = '',
  $distribution = '',
){
  validate_string($component)
  validate_string($distribution)

  include ::aptly

  $aptly_cmd = '/usr/bin/aptly repo'

  if empty($component) {
    $component_arg = ''
  } else{
    $component_arg = "-component=\"${component}\""
  }
  if empty($distribution) {
    $distribution_arg = ''
  } else{
    $distribution_arg = "-distribution=\"${distribution}\""
  }


  exec{ "aptly_repo_create-${title}":
    command =>
      "${aptly_cmd} create ${distribution_arg} ${component_arg} ${title}",
    unless  => "${aptly_cmd} show ${title} >/dev/null",
    user    => $::aptly::user,
    require => [
      Class['::aptly'],
    ],
  }
}
