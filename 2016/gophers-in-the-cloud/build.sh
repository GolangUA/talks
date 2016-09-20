#!/bin/bash
export GO15VENDOREXPERIMENT=1
export GOPATH="$(pwd)"
go get github.com/Masterminds/glide
mkdir -p $GOPATH/{bin,src/app}
mv *.{go,yaml,lock} $GOPATH/src/app/
mv vendor/ $GOPATH/src/app/
cd $GOPATH/src/app/
$GOPATH/bin/glide install
go build -a -o $GOPATH/bin/application
