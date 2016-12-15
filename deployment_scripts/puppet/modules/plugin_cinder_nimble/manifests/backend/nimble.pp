# nimble.pp

class plugin_cinder_nimble::backend::nimble (
  $cinder_nimble          = $plugin_cinder_nimble::params::cinder_nimble
) {

  include cinder::params

  $range_array = range('1', $cinder_nimble['no_backends'])
  plugin_cinder_nimble::backend::add_backend { $range_array: }
  service { $cinder::params::volume_service: }
}
