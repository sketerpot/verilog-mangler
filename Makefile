# The only target that does anything is install. It requires root.
all:

clean:
	rm -f *~

dist:
	mkdir vmangle-0.2
	cp configure INSTALL Makefile vmangle.py README vmangle.1 vmangle-0.2/
	tar -zcf vmangle-0.2.tar.gz vmangle-0.2/
	rm -R vmangle-0.2/

install:
	install -c 'vmangle.py' '/usr/local/bin/vmangle'
	install -c 'vmangle.1' '/usr/local/man/man1/vmangle.1'