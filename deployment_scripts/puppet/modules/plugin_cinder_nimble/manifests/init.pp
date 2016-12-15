# init.pp

class plugin_cinder_nimble (
) inherits plugin_cinder_nimble::params {

  class { $plugin_cinder_nimble::params::nimble_backend_class: }
}
