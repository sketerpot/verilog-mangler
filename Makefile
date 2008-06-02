# The only target that does anything is install. It requires root.
all:

clean:
	rm -f *~

dist:
	mkdir vmangle-0.1
	cp configure INSTALL Makefile vmangle.py README vmangle-0.1/
	tar -zcf vmangle-0.1.tar.gz vmangle-0.1/
	rm -R vmangle-0.1/

install:
	install -c 'vmangle.py' '/usr/local/bin/vmangle'