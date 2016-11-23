class plugin_cinder_nimble::backend::disable_default_type (
  $config_file,
) {

  include plugin_cinder_nimble::params
  include cinder::params

  $cinder_nimble = hiera_hash('cinder_nimble', {})

  if ($cinder_nimble['nimble_grouping']) == true {
    $nimble_default_type_set = $cinder_nimble['nimble_group_default_backend']
  }
  else {
    $nimble_default_type_set = $cinder_nimble['nimble1_default_backend'] or
                               $cinder_nimble['nimble2_default_backend'] or
                               $cinder_nimble['nimble3_default_backend'] or
                               $cinder_nimble['nimble4_default_backend'] or
                               $cinder_nimble['nimble5_default_backend']
  }

  if ($nimble_default_type_set) == true {
    ini_setting {"disable_default_type_${nimble_backend_type}":
      ensure               => absent,
      section              => 'DEFAULT',
      path                 => $config_file,
      setting              => 'default_volume_type',
    }

    Cinder_config<||> ~> Service['cinder-api']

    service { 'cinder-api':
      ensure     => stopped,
      name       => $::cinder::params::api_service,
      enable     => true,
      hasstatus  => true,
      hasrestart => true,
    }
  }
}
