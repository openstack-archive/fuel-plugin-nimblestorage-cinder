class plugin_cinder_nimble::backend::set_nimble_cinder_type (
) {
  $storage_hash    = hiera_hash('storage', {})
  $backends        = $storage_hash['volume_backend_names']

  $available_backends        = delete_values($backends, false)
  $available_backend_names   = keys($available_backends)

  ::osnailyfacter::openstack::manage_cinder_types { $available_backend_names:
    ensure               => 'present',
    volume_backend_names => $available_backends,
  }
}
