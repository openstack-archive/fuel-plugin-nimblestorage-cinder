class plugin_cinder_nimble::backend::set_extraspecs_perfpol (
) {
  $storage_hash    = hiera_hash('storage', {})
  $nimble_perfpol    = $storage_hash['nimble_perfpol']
  if ! empty($nimble_perfpol) {
    $available_backend_names   = keys($nimble_perfpol)
    ::osnailyfacter::openstack::manage_cinder_types { $available_backend_names:
      ensure               => 'present',
      volume_backend_names => $nimble_perfpol,
      key                  => 'nimble:perfpol-name'
    }
  }
}
