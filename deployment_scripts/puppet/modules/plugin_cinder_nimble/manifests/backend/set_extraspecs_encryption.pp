# set_extraspecs_encryption.pp

class plugin_cinder_nimble::backend::set_extraspecs_encryption (
) {
  $storage_hash         = hiera_hash('storage', {})
  $nimble_encryption    = $storage_hash['nimble_encryption']
  $available_backends        = delete_values($nimble_encryption, '__dummy__')
  $available_backend_names   = keys($available_backends)
  ::osnailyfacter::openstack::manage_cinder_types { $available_backend_names:
    ensure               => 'present',
    volume_backend_names => $available_backends,
    key                  => 'nimble:encryption'
  }
}
