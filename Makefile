.PHONY: default server client clean all release-all assets client-assets server-assets contributors

BUILDTAGS=release
default: all

server: 
	go install -tags '$(BUILDTAGS)' cmd/ngrokd/*.go

client: 
	go install -tags '$(BUILDTAGS)' cmd/ngrok/*.go

assets: client-assets server-assets

client-assets:
	go-bindata -nomemcopy -pkg=assets -tags=$(BUILDTAGS) \
		-debug=$(if $(findstring debug,$(BUILDTAGS)),true,false) \
		-o=client/assets/assets_$(BUILDTAGS).go \
		assets/client/...

server-assets:
	go-bindata -nomemcopy -pkg=assets -tags=$(BUILDTAGS) \
		-debug=$(if $(findstring debug,$(BUILDTAGS)),true,false) \
		-o=server/assets/assets_$(BUILDTAGS).go \
		assets/server/...

release-client: BUILDTAGS=release
release-client: client

release-server: BUILDTAGS=release
release-server: server

release-all: release-client release-server

all: client server

clean:
	rm -rf client/assets/ server/assets/

contributors:
	echo "Contributors to ngrok, both large and small:\n" > CONTRIBUTORS
	git log --raw | grep "^Author: " | sort | uniq | cut -d ' ' -f2- | sed 's/^/- /' | cut -d '<' -f1 >> CONTRIBUTORS
