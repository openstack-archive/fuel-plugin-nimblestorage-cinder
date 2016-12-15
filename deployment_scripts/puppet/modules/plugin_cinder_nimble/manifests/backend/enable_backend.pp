# enable_backend.pp

define plugin_cinder_nimble::backend::enable_backend (
  $config_file = $plugin_cinder_nimble::params::config_file
) {

  include plugin_cinder_nimble::params

  ini_subsetting {"enable_${name}_backend":
    ensure               => present,
    section              => 'DEFAULT',
    key_val_separator    => '=',
    path                 => $config_file,
    setting              => 'enabled_backends',
    subsetting           => $name,
    subsetting_separator => ',',
    use_exact_match      => true,
  }
}
