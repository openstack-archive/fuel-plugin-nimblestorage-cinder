=============
Nimble plugin
=============

The plugin provides support for the ``Nimble Cinder driver for OpenStack`` with Nimble Storage arrays.
The plugin uses the Nimble Storage Cinder driver, which is the OpenStack Block storage driver for all Nimble arrays.

The Nimble Cinder driver supports iSCSI to communicate and provide data access to the Nimble arrays for the OpenStack cluster. 
The Nimble Cinder driver is configured to provision OpenStack volumes on a Nimble array via the iSCSI protocol. The Compute nodes will discover the Nimble lin once the request is made to attach to an OpenStack instance. 
The OpenStack volumes created by the Nimble Cinder driver will also be Nimble Storage array volumes. They would then be used by OpenStack to access data 
for those cinder volumes, which are supported by Nimble Storage array volumes. 

Features
--------
* Nimble Operating System 2.3.16 and above
* Support for iSCSI and Fibre Channel protocols
* Cinder multibackend is supported
* Supports Nimble Operating System features via configuration options for the Nimble Cinder driver

Requirements
------------
======================= =================================
Requirement             Version/Comment
======================= =================================
Fuel                    9.0 or 9.1
Nimble OS               2.3.16 and above
Nimble Cinder driver    2.0.3 
======================= =================================


Prerequisites
-------------
* If you plan to use the plugin with **Nimble OS**, it is required that the array(s) are available for the OpenStack cluster.


Release Notes
-------------
* Initial release for MOS 9.0 support


Limitations
-----------
* Only five Nimble backends can be configured with the Nimble Cinder Fuel Plugin.
