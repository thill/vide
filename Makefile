.PHONY: install
install:
	mkdir -p /usr/local/etc/vide/templates
	cp -r ./templates/command /usr/local/etc/vide/templates/
	cp vide /usr/local/bin/

.PHONY: install-templates
install-templates:
	mkdir -p /usr/local/etc/vide/templates
	cp -r ./templates/* /usr/local/etc/vide/templates/

.PHONY: uninstall
uninstall:
	rm -rf /usr/local/etc/vide
	rm -f /usr/local/bin/vide

