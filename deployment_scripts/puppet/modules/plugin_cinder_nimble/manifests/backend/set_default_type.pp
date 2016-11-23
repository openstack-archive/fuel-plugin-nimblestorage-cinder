class plugin_cinder_nimble::backend::set_default_type (
  $config_file,
  $nimble_default_type_set,
  $nimble_backend_type
) {

  include plugin_cinder_nimble::params
  include cinder::params

  if ($nimble_default_type_set) == true {
    ini_subsetting {"set_default_type_${nimble_backend_type}":
      ensure               => present,
      section              => 'DEFAULT',
      key_val_separator    => '=',
      path                 => $config_file,
      setting              => 'default_volume_type',
      subsetting           => $nimble_backend_type,
    }

    Cinder_config<||> ~> Service['cinder-api']

    service { 'cinder-api':
      ensure     => running,
      name       => $::cinder::params::api_service,
      enable     => true,
      hasstatus  => true,
      hasrestart => true,
    }
  }
}
