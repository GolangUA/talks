SHELL := /bin/bash
default: build

# Final binary should be stored in directory /var/app/staging and then after succes build it will be moved to the /var/app/current, where you should start it in the Procfile
# default GOPATH=/var/app/current and PWD=/var/app/staging

src: 
	export GOPATH="$(CURDIR)" && \
	echo $$GOPATH && mkdir -p $$GOPATH/{src/app,bin} && mv *.{go,yaml,lock} $$GOPATH/src/app/ && mv vendor/ $$GOPATH/src/app/
glide: src
	export GOPATH="$(CURDIR)" && \
	go get github.com/Masterminds/glide
vendor: glide
	export GOPATH="$(CURDIR)" && \
	pushd $$GOPATH/src/app/ && $$GOPATH/bin/glide install && popd
build: vendor
	export GOPATH="$(CURDIR)" && \
	export GO15VENDOREXPERIMENT=1 && pushd $$GOPATH/src/app/ && go build -a -o $$GOPATH/bin/application && popd
