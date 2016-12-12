class plugin_cinder_nimble::backend::set_extraspecs_multi_init (
) {
  $storage_hash    = hiera_hash('storage', {})
  $nimble_multi_init    = $storage_hash['nimble_multi_init']
  $available_backends        = delete_values($nimble_multi_init, '__dummy__')
  $available_backend_names   = keys($available_backends)
  ::osnailyfacter::openstack::manage_cinder_types { $available_backend_names:
    ensure               => 'present',
    volume_backend_names => $available_backends,
    key                  => 'nimble:multi-initiator'
  }
}
