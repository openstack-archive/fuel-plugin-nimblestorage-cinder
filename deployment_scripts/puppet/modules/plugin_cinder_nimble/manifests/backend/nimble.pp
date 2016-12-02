class plugin_cinder_nimble::backend::nimble (
  $cinder_nimble          = $plugin_cinder_nimble::params::cinder_nimble
) {

  include cinder::params

  define plugin_cinder_nimble::add_backend (
    $array, # pass the original $name
  ) {
    #notice(inline_template('NAME: <%= name.inspect %>'))

    # build a unique name...
    $length = inline_template('<%= array.length %>')
    $ulength = inline_template('<%= array.uniq.length %>')
    if ( "${length}" != '0' ) and ( "${length}" != "${ulength}" ) {
        fail('Array must not have duplicates.')
    }
    # if array had duplicates, this wouldn't be a unique index
    $index = inline_template('<%= array.index(name) %>')

    plugin_cinder_nimble::backend::set_nimble_backend { "$index" :
      backend_id => $name,
      index => "$index",
    }
  }

  # Should work from Puppet >= 4.0.0 onwards which has Future parser
  /*
  range("1", "$cinder_nimble['no_backends']").each |$id| {
    # Set backend details
    class { 'plugin_cinder_nimble::backend::set_nimble_backend' :
      $backend_id => $id,
    }
  }
  */

  $range_array = range("1", $cinder_nimble['no_backends'])
  plugin_cinder_nimble::add_backend { $range_array:
    array => $range_array,
  }
  service { $cinder::params::volume_service: }
}
