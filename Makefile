GO_SOURCES = audio.go avconv.go client.go go.mod go.sum \
             playable.go ./cmd/telecom-native/main.go

GO ?= go

.PHONY: clean all

all: shared static client

shared: $(GO_SOURCES)
	$(GO) build -o telecom.so $(GOFLAGS) -buildmode=c-shared \
                       ./cmd/telecom-native/main.go

static: $(GO_SOURCES)
	$(GO) build -o telecom.so $(GOFLAGS) -buildmode=c-archive \
                       ./cmd/telecom-native/main.go

clean:
	rm -f telecom.so telecom.a telecom.h

ifeq ($(PREFIX),)
	PREFIX := /usr/local
endif

install: all
	install -d $(DESTDIR)$(PREFIX)/lib/
	install -m 644 telecom.a $(DESTDIR)$(PREFIX)/lib/libtelecom.a
	install -m 644 telecom.so $(DESTDIR)$(PREFIX)/lib/libtelecom.so
	install -d $(DESTDIR)$(PREFIX)/include/
	install -m 644 telecom.h $(DESTDIR)$(PREFIX)/include/telecom.h
