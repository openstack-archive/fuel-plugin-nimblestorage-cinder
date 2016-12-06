class plugin_cinder_nimble::backend::set_nimble_cinder_type (
) {
  $storage_hash    = hiera_hash('storage', {})
  $backends        = $storage_hash['nimble_volume_backend_names']

  $available_backends        = delete_values($backends, false)
  $available_backend_names   = keys($available_backends)

  $unavailable_backends      = delete($backends, $available_backend_names)
  $unavailable_backend_names = keys($unavailable_backends)

  ::osnailyfacter::openstack::manage_cinder_types { $available_backend_names:
    ensure               => 'present',
    volume_backend_names => $available_backends,
  }
  ::osnailyfacter::openstack::manage_cinder_types { $unavailable_backend_names:
    ensure => 'absent',
  }
}
