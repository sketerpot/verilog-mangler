# The only target that does anything is install. It requires root.
all:

install:
	install -c 'vmangle.py' '/usr/local/bin/vmangle'