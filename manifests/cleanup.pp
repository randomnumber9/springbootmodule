class springbootmodule::cleanup (
  $cacheHistory  =  0,
  $homePath      = '/opt/springboot'
) {

  $keepCurrent = $cacheHistory + 1

  #exec { 'cleanup-cache-zips':
  #  command     => "ls -tr . | head -n $(expr $(ls . | wc -l) - ${keepCurrent}) | xargs rm -f",
  #  cwd         => "${homePath}/cache/zip",
  #  path        => ['/bin','/usr/bin','/usr/local/bin'],
  #  user        => 'springboot',
  #}

  #exec { 'cleanup-cache-dirs':
    #command => "ls -tr . | head -n $(expr $(ls . | wc -l) - ${keepCurrent}) | xargs rm -rf",
    #cwd     => "$homePath/apps",
    #path    => ['/bin','/usr/bin','/usr/local/bin'],
    #user    => 'springboot',
  #}

}
