===========
Utilization
===========

Usage
-----
The Nimble Fuel Plugin for Cinder will set up the appropriate configuration for Cinder backends with ``Nimble Storage``. With the deployment of MOS 9.0 thru Fuel, ensure that you enable the cinder Nimble Plugin. 


Verification
------------
To perform functional testing you should:

* List the extra-specs to validate your deployment of volume types, extra specs and backends
* Create a volume via Cinder and set ``volume type`` based on your configuration
* Attach the volume to any available instance
* Validate the Cinder volume was properly created on the Nimble array

Troubleshooting
---------------
* The primary problems that users experience with Cinder backends are configuration issues. Verify that the Nimble array information is correct within the cinder.conf file
* Ensure that all of your Cinder backends are enabled
* Validate that the extra-specs were properly defined
* Validate that the Compute nodes can properly discover the Nimble array volumes
