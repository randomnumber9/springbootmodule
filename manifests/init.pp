# == Class: springbootmodule
#
# Full description of class springboot here.
#
# === Parameters
#
# [*sample_parameter*]
#   Explanation of what this parameter affects and what it defaults to.
#
class springbootmodule (
  $owner = "springboot",
  $group = "springboot",
  $homepath = "/opt/springboot"
) {

  group { "${group}":
    ensure     => present,
  }
  ->
  user { "${owner}":
    ensure     => present,
    gid        => "${group}",
    shell      => '/bin/bash',
    home       => "/home/${owner}",
  }
  ->
  file { "springbootappdir":
    path     => "${homepath}",
    ensure   => "directory",
    owner    => "${owner}",
    group    => "${group}",
    mode     => 0775,
  }
  file { "apps":
    path     => "${homepath}/apps",
    ensure   => "directory",
    owner    => "${owner}",
    group    => "${group}",
    require  => File['springbootappdir'],
    mode     => 0775,
  }
  file { "conf":
    path     => "${homepath}/conf",
    ensure   => "directory",
    owner    => "${owner}",
    group    => "${group}",
    require  => File['springbootappdir'],
    mode     => 0775,
  }
  file { "logs":
    path     => "${homepath}/logs",
    ensure   => "directory",
    owner    => "${owner}",
    group    => "${group}",
    require  => File['springbootappdir'],
    mode     => 0775,
  }
  file { "cache":
    path     => "${homepath}/cache",
    ensure   => "directory",
    owner    => "${owner}",
    group    => "${group}",
    require  => File['springbootappdir'],
    mode     => 0775,
  }
}
