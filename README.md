# ganeti-instance-cloudimage

## Description

ganeti-instance-cloudimage is a Ganeti OS image provider for using cloud
images with cloud-init as provided by many Linux distributions.  Images are
downloaded, cached and written to the block device passed by Ganeti.
cloud-init is configured by preseeding the NoCloud source on-disk.  Currently
qcow2, raw and xz-compressed raw images are supported.

A script for Debian cloud images is included, other distributions can be added
easily by adding the distribution name to `variants.list` and creating a
corresponding script named `variant-<name>` which downloads and verifies the
image.

Note: The Debian project does not provide signed images, please see
<https://cloud.debian.org/images/cloud/> for information on how to ensure the
integrity of the downloaded images.

## Build instructions

ganeti-instance-cloudimage has been tested with Linux and Ganeti 3.0.  The
following tools are required to build ganeti-instance-cloudimage:

- GNU make >= 3.81
- GNU or BSD install

The following utilities are required to run ganeti-instance-cloudimage:

- Bash >= 5.0
- GNU Coreutils
- losetup, partx, uuidgen (util-linux)
- qemu-img (QEMU)
- xz (XZ Utils)

Before building ganeti-instance-cloudimage check the commented macros in the
Makefile for any macros you may need to override depending on your operating
system.

By default, all files will be installed under the "/usr/local" directory, a
different installation path prefix can be set via the `prefix` macro.  In
addition, a second path prefix can be specified via the `DESTDIR` macro which
will be prepended to any path, incuding the `prefix` macro path prefix.  In
contrast to `prefix`, the path specified via the `DESTDIR` macro will only be
prepended to paths during installation and not be used for constructing
internal paths.

ganeti-instance-cloudimage requires an unprivileged user account which is used
for downloading images and needs to be specified in the configuration file
which is installed to "/etc/default/ganeti-instance-cloudimage" by default.

The following instructions assume that `make` is GNU make, on some platforms
it may be installed under a different name or a non-default path.  In order to
start the build process run `make all`.  After a successful build, run `make
install` to install the program, any associated data files and the
documentation.

Previously generated files an be removed by running `make clean`, any additional,
generated files which are not removed by the `clean` target can be removed by
running `make clobber`.

## License

Except otherwise noted, all files are Copyright (C) 2023 Guido Berhoerster and
distributed under the following license terms:

Copyright (C) 2023 Guido Berhoerster <guido+freiesoftware@berhoerster.name>

This program is free software; you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation; either version 2 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful, but
WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program; if not, write to the Free Software
Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA
02110-1301, USA.
