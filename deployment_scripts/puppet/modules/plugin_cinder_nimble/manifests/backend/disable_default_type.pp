# disable_default_type.pp

class plugin_cinder_nimble::backend::disable_default_type (
  $config_file,
) {

  include plugin_cinder_nimble::params
  include cinder::params

  ini_setting {'disable_default_type':
    ensure  => absent,
    section => 'DEFAULT',
    path    => $config_file,
    setting => 'default_volume_type',
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
