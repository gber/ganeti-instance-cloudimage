#
# Copyright (C) 2023 Guido Berhoerster <guido+freiesoftware@berhoerster.name>
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 2 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful, but
# WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
# General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA
# 02110-1301, USA.

PACKAGE =	ganeti-instance-cloudimage
VERSION =	0.1
DISTNAME :=	$(PACKAGE)-$(VERSION)

INSTALL :=	install
INSTALL.exec :=	$(INSTALL) -D -m 0755
INSTALL.data :=	$(INSTALL) -D -m 0644
PAX :=		pax
GZIP :=		gzip
SED :=		sed

DESTDIR ?=
prefix ?=	/usr/local
datadir ?=	$(prefix)/share
sysconfdir ?=	/etc

SHELL_PATH ?= /usr/local/sbin:/sbin:/usr/sbin:/usr/local/bin:/bin:/usr/bin

.DEFAULT_TARGET = all

.PHONY: all clean clobber dist install

BUILT_FILES =	common.sh
SCRIPT_FILES =	create \
		variant-debian \
		export \
		import \
		rename \
		test \
		verify
DATA_FILES =	default \
		ganeti_api_version \
		parameters.list \
		variants.list

all: $(SCRIPT_FILES) $(DATA_FILES) $(BUILT_FILES)

%.sh: %.sh.in
	$(SED) -e 's|@sysconfdir@|$(sysconfdir)|g' \
	    -e 's|@shellpath@|$(SHELL_PATH)|g' $< >$@

install: all
	for script in $(SCRIPT_FILES); do \
	    $(INSTALL.exec) "$${script}" \
	    "$(DESTDIR)$(datadir)/ganeti/os/cloudimage/$${script}"; \
	done
	for data in common.sh ganeti_api_version parameters.list; do \
	    $(INSTALL.data) "$${data}" \
	    "$(DESTDIR)$(datadir)/ganeti/os/cloudimage/$${data}"; \
	done
	$(INSTALL.data) variants.list \
	    "$(DESTDIR)$(sysconfdir)/ganeti/instance-cloudimage/variants.list"
	ln -sf "$(sysconfdir)/ganeti/instance-cloudimage/variants.list" \
	    "$(DESTDIR)$(datadir)/ganeti/os/cloudimage/variants.list"
	$(INSTALL.data) default \
	    "$(DESTDIR)$(sysconfdir)/default/ganeti-instance-cloudimage"

clean:
	rm -f $(BUILT_FILES)

clobber: clean

dist: clobber
	$(PAX) -w -x ustar -s ',.*/\..*,,' -s ',./[^/]*\.tar\.gz,,' \
	    -s ',^\.$$,,' -s ',\./,$(DISTNAME)/,' . | \
	    $(GZIP) > $(DISTNAME).tar.gz
