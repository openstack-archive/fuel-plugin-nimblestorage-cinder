class plugin_cinder_nimble::backend::set_extraspecs_encryption (
) {
  $storage_hash         = hiera_hash('storage', {})
  $nimble_encryption    = $storage_hash['nimble_encryption']
  $available_backend_names   = keys($nimble_encryption)	
  ::osnailyfacter::openstack::manage_cinder_types { $available_backend_names:
    ensure               => 'present',
    volume_backend_names => $nimble_encryption,
    key                  => 'nimble:encryption'
  }
}
