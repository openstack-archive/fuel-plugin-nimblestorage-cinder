# add_backend.pp 

define plugin_cinder_nimble::backend::add_backend (
) {
  plugin_cinder_nimble::backend::set_nimble_backend { $name :
    backend_id => $name,
  }
}

