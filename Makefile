GO			= go
GOCCFLAGS 	= -v
GOLDFLAGS   = -ldflags="-s -w"
PREFIX		= /usr/local

PROGRAM_NAME=eth-healthcheck
SOURCES=src/cmd/main.go

all: build
build: build/$(PROGRAM_NAME)

build/$(PROGRAM_NAME) : $(SOURCES)
	$(GO) build -o $@ $(GOCCFLAGS) $(GOLDFLAGS) $^

pkg_info :
	echo PACKAGE_NAME=\"$(PROGRAM_NAME)\" "\n"\
	PACKAGE_DESCRIPTION=\"HAproxy healthcheck program for Etherium nodes.\" "\n"\
	PACKAGE_VERSION=\"0.1.0\" "\n"\
	PACKAGE_PREFIX=\"$(PREFIX:/%=%)\" "\n"\
	PACKAGE_PROGRAM=\"$(PROGRAM_NAME)\" > build/pkg_info

package : build pkg_info

package_deb: package
	./scripts/pkg.sh deb $(realpath build)
