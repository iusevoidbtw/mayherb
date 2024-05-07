CC     ?= CC
OUTPUT  = mayflower
SOURCES = draw.c util.c mayflower.c wlr-layer-shell-unstable-v1.c xdg-shell-protocol.c
HEADERS = config.h draw.h util.h wlr-layer-shell-unstable-v1.h xdg-shell-client-protocol.h

CFLAGS  = -g -Os -std=c99 -pedantic -Wall -Wextra -Wno-unused-variable -lcairo -lwayland-client -lwayland-cursor -lpthread

PREFIX ?= /usr/local

all: $(OUTPUT)

$(OUTPUT): $(SOURCES) $(HEADERS)
	$(CC) $(CFLAGS) -o $(OUTPUT) $(SOURCES)

config.h: config.def.h
	cp -i config.def.h config.h

wlr-layer-shell-unstable-v1.c: wlr-layer-shell-unstable-v1.xml
	wayland-scanner private-code wlr-layer-shell-unstable-v1.xml wlr-layer-shell-unstable-v1.c

wlr-layer-shell-unstable-v1.h: wlr-layer-shell-unstable-v1.xml
	wayland-scanner client-header wlr-layer-shell-unstable-v1.xml wlr-layer-shell-unstable-v1.h

xdg-shell-protocol.c: /usr/share/wayland-protocols/stable/xdg-shell/xdg-shell.xml
	wayland-scanner private-code /usr/share/wayland-protocols/stable/xdg-shell/xdg-shell.xml xdg-shell-protocol.c

xdg-shell-client-protocol.h: /usr/share/wayland-protocols/stable/xdg-shell/xdg-shell.xml
	wayland-scanner client-header /usr/share/wayland-protocols/stable/xdg-shell/xdg-shell.xml xdg-shell-client-protocol.h


install: $(OUTPUT)
	mkdir -p ${DESTDIR}${PREFIX}/bin
	cp -f $(OUTPUT) ${DESTDIR}${PREFIX}/bin

uninstall:
	rm -f ${DESTDIR}${PREFIX}/bin/$(OUTPUT)

clean:
	rm -f $(OUTPUT) *.o wlr-layer-shell-unstable-v1.c wlr-layer-shell-unstable-v1.h xdg-shell-client-protocol.h xdg-shell-protocol.c

.PHONY: all install uninstall clean