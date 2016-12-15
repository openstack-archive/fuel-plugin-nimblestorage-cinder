# set_extraspecs_perfpol.pp

class plugin_cinder_nimble::backend::set_extraspecs_perfpol (
) {
  $storage_hash    = hiera_hash('storage', {})
  $nimble_perfpol    = $storage_hash['nimble_perfpol']
  $available_backends        = delete_values($nimble_perfpol, '__dummy__')
  $available_backend_names   = keys($available_backends)
  ::osnailyfacter::openstack::manage_cinder_types { $available_backend_names:
    ensure               => 'present',
    volume_backend_names => $available_backends,
    key                  => 'nimble:perfpol-name'
  }
}
