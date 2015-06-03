define springbootmodule::application(
  $source,
  $ensure       = 'installed',
  $version      = '1.0',
  $app_name     = $title,
  $port         = '8080',
  $path         = '/opt/springboot',
  $service      = true,
  $enable       = true,
  $exec_params  = '',
  $addl_params  = '',
  $app_config = undef,
  $security_content = undef,
  $logback_config = undef,
  $owner = "springboot",
  $group = "springboot",
  $service_name = "springboot-${title}",
  $security_file = 'puppet:///modules/springbootmodule/security.xml',
  $app_file = 'puppet:///modules/springbootmodule/app.xml',
  $filename = inline_template('<%= require \'uri\'; File.basename(URI::parse(@source).path) %>'),
  $cleandirs = true,
)
{
  Exec { user => 'springboot'}

  require springbootmodule
  case $ensure {
    'installed', 'present' : {

      file {"${path}/cache/${app_name}" :
      ensure => 'directory',
      owner    => "${owner}",
      group    => "${group}",
      mode     => 0775
      } ->

      exec { "/usr/bin/wget -N ${source}":
        alias => "springbootlatest${title}",
        cwd => "${path}/cache/${app_name}",
      } ->

      file { "${path}/cache/${app_name}/${filename}":
        alias   => "springbootcache${title}",
        ensure  => 'file',
      } ->

      exec { "/usr/bin/service ${service_name} stop":
        alias       => "springbootstop${title}",
        cwd         => "${path}/cache/${app_name}",
        subscribe   => File["springbootcache${title}"],
        refreshonly => true,
        before      => File["springbootmaster${title}"],
      } ->

      file {"${path}/apps/${app_name}" :
        ensure => 'directory',
        owner    => "${owner}",
        group    => "${group}",
        mode     => 0775,
      } ->

      file { "${path}/apps/${app_name}/${filename}":
        alias   => "springbootmaster${title}",
        ensure  => 'file',
        notify  => Service[$service_name],
        source  => "${path}/cache/${app_name}/${filename}",
      } ->

      file {"${path}/conf/${app_name}" :
        ensure => 'directory',
        owner    => "${owner}",
        group    => "${group}",
        mode     => 0775,
      } ->

      file {"${path}/logs/${app_name}" :
        ensure => 'directory',
        owner    => "${owner}",
        group    => "${group}",
        mode     => 0775,
      }

      if ( $service == true ) {
        file {"/etc/init.d/${service_name}":
          ensure  => 'file',
          content => template('springbootmodule/initd-springboot-appl.erb'),
          owner   => 'root',
          group   => 'root',
          mode    => '0755',
          notify => Service[$service_name],
      }
        service { $service_name :
          ensure     => 'running',
          enable     => $enable,
          hasstatus  => true,
          hasrestart => true,
        }
      }

      if ( $cleandirs ) {

        exec { "find ! -name ${filename} -type f -exec rm -f {} +":
          cwd       =>  "${path}/cache/${app_name}",
          subscribe =>  Service[$service_name],
          path      =>  "/opt"
        }

      }

    }
    'absent': {
      service { $service_name :
        ensure => stopped,
      } ->
      file {"/etc/init.d/${service_name}":
        ensure => absent,
      }
    }
    default: { err ( "Unknown ensure value: '${ensure}'" ) }
  }
}
