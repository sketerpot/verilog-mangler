# The only target that does anything is install. It requires root.
all:

clean:
	rm -f *~

dist:
	mkdir vmangle-0.3
	cp configure INSTALL Makefile vmangle.py README vmangle.1 extract_module_names.py add_qii_prefix.py QII-example-cells.v vmangle-0.3/
	tar -zcf vmangle-0.3.tar.gz vmangle-0.3/
	rm -R vmangle-0.3/

install:
	install -c 'vmangle.py' '/usr/local/bin/vmangle'
	install -c 'vmangle.1' '/usr/local/man/man1/vmangle.1'