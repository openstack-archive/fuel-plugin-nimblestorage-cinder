# Since Fuel 8.0 has its own task to set Cinder volume-types. We add our modifications before this task is executed.

notice('MODULAR: nimble-hiera-override')

$cinder_nimble   = hiera_hash('cinder_nimble', {})
$no_backends     = $cinder_nimble['no_backends']

$hiera_dir    = '/etc/hiera/plugins'
$plugin_yaml  = 'cinder_nimble.yaml'
$plugin_name  = 'cinder_nimble'

file { $hiera_dir:
  ensure => directory,
}

$range_array = range("1", $no_backends)

# Create content based on grouping flag.
# This is separated to keep the inline content and conditions tidy.
if ($cinder_nimble['nimble_grouping']) == true {
$content = inline_template('
storage:
  nimble_volume_backend_names:
    <%= @cinder_nimble["nimble_group_backend_type"] %>: <%= @cinder_nimble["nimble_group_backend_name"] %>
  nimble_encryption:
    <%= @cinder_nimble["nimble_group_backend_type"] %>: <%= @cinder_nimble["nimble_group_encryption"] -%>
<% if @cinder_nimble["nimble_group_perfpol"] != "" %>
  nimble_perfpol:
    <%= @cinder_nimble["nimble_group_backend_type"] %>: <%= @cinder_nimble["nimble_group_perfpol"] -%>
<% end %>
  nimble_multi_init:
    <%= @cinder_nimble["nimble_group_backend_type"] %>: <%= @cinder_nimble["nimble_group_multi_init"] %>
')
}
else {
$content = inline_template('
storage:
  nimble_volume_backend_names:
<% @range_array.each do |i| -%>
    <%= @cinder_nimble["nimble#{i}_backend_type"] %>: <%= @cinder_nimble["nimble#{i}_backend_name"] %>
<% end %>
  nimble_encryption:
<% @range_array.each do |i| -%>
    <%= @cinder_nimble["nimble#{i}_backend_type"] %>: <%= @cinder_nimble["nimble#{i}_encryption"] %>
<% end %>
  nimble_perfpol:
    __dummy__: __dummy__
<% @range_array.each do |i| -%>
<% if @cinder_nimble["nimble#{i}_perfpol"] != "" -%>
    <%= @cinder_nimble["nimble#{i}_backend_type"] %>: <%= @cinder_nimble["nimble#{i}_perfpol"] -%>
<% end %>
<% end %>
  nimble_multi_init:
<% @range_array.each do |i| -%>
    <%= @cinder_nimble["nimble#{i}_backend_type"] %>: <%= @cinder_nimble["nimble#{i}_multi_init"] %>
<% end %>
')
}

file { "${hiera_dir}/${plugin_yaml}":
  ensure  => file,
  content => $content,
}

# Workaround for bug 1598163
exec { 'patch_puppet_bug_1598163':
  path    => '/usr/bin:/bin:/usr/sbin:/sbin:/usr/local/bin',
  cwd     => '/etc/puppet/modules/osnailyfacter/manifests/globals',
  command => "sed -i \"s/hiera('storage/hiera_hash('storage/\" globals.pp",
  onlyif  => "grep \"hiera('storage\" globals.pp"
}
