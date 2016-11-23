class plugin_cinder_nimble::params (
) {

  $config_file = '/etc/cinder/cinder.conf'
  $cinder_nimble = hiera_hash('cinder_nimble', {})
  $nimble_backend_class = 'plugin_cinder_nimble::backend::nimble'
}
