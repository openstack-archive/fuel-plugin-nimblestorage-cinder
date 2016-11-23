class plugin_cinder_nimble (
) inherits plugin_cinder_nimble::params {

  class { $nimble_backend_class: }
}
