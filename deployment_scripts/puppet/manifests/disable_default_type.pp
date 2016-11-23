notice('MODULAR: nimble-disable-default-volume-type')

$config_file = '/etc/cinder/cinder.conf'

class { 'plugin_cinder_nimble::backend::disable_default_type' :
  config_file => $config_file,
}
