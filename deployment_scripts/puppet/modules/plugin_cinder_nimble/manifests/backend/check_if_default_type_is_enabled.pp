# check_if_default_type_is_enabled.pp 

define plugin_cinder_nimble::backend::check_if_default_type_is_enabled (
  $enable,
  $cinder_nimble = $plugin_cinder_nimble::params::cinder_nimble,
  $config_file = $plugin_cinder_nimble::params::config_file
) {

  include plugin_cinder_nimble::params
  include cinder::params

  if (($cinder_nimble["nimble${name}_default_backend"]) == true) and
      (($cinder_nimble["nimble${name}_backend_type"]) != '') {
    if ($enable) == true {
      class { 'plugin_cinder_nimble::backend::set_default_type' :
        config_file         => $config_file,
        nimble_backend_type => $cinder_nimble["nimble${name}_backend_type"],
      }
    }
    else {
      class { 'plugin_cinder_nimble::backend::disable_default_type' :
        config_file => $config_file,
      }
    }
  }
}
